/* Searchable select: progressively enhances <select data-searchable="true">
 * elements into a plain search bar, without changing how the form submits
 * or how ASP.NET's unobtrusive validation works. Matches only appear once
 * the user types something - focusing or clicking the field does not pop
 * open a full list of every option, so it reads as a search box rather
 * than a disguised <select>.
 *
 * The original <select> is kept in the DOM (visually hidden, not
 * display:none, so jQuery Validate's default `ignore: ":hidden"` doesn't
 * skip it) and stays the single source of truth: selecting an option here
 * sets select.value and fires a native "change" event, so any existing
 * $('#CustomerID').on('change', ...) handler (e.g. the Customer -> Vehicle
 * cascading dropdowns) keeps working unmodified.
 *
 * Works with selects added to the page after load (e.g. a cloned line-item
 * row) and with selects whose <option> list or disabled state is changed
 * programmatically after init (e.g. the Vehicle dropdown repopulated via
 * AJAX once a Customer is picked).
 */
(function () {
    "use strict";

    var idCounter = 0;

    function nextId(prefix) {
        idCounter += 1;
        return prefix + "-" + idCounter;
    }

    function optionDisplayText(option) {
        var text = option.textContent || "";
        return text.trim();
    }

    function initOne(select) {
        if (!select || select.dataset.ssInit === "true") {
            return;
        }
        select.dataset.ssInit = "true";

        var wrap = document.createElement("div");
        wrap.className = "ss-wrap";
        select.parentNode.insertBefore(wrap, select);

        var input = document.createElement("input");
        input.type = "text";
        // Only take layout/sizing classes from the select (e.g. "form-select-sm"),
        // not functional hook classes like "product-select" - those are meant to
        // target the real <select> (e.g. $(document).on('change', '.product-select', ...)),
        // not this decorative stand-in, or jQuery selectors elsewhere would double-match.
        var sizeClasses = (select.className.match(/\bform-select-\S+/g) || []).join(" ");
        input.className = ("form-control ss-input " + sizeClasses).trim();
        input.autocomplete = "off";
        input.setAttribute("role", "combobox");
        input.setAttribute("aria-autocomplete", "list");
        input.setAttribute("aria-expanded", "false");
        if (select.disabled) {
            input.disabled = true;
        }

        var menu = document.createElement("div");
        menu.className = "ss-menu";
        menu.setAttribute("role", "listbox");
        menu.hidden = true;
        menu.id = nextId("ss-menu");
        input.setAttribute("aria-controls", menu.id);

        var empty = document.createElement("div");
        empty.className = "ss-empty";
        empty.textContent = "No matches found";
        empty.hidden = true;
        menu.appendChild(empty);

        wrap.appendChild(input);
        wrap.appendChild(menu);
        wrap.appendChild(select);
        select.classList.add("ss-native-hidden");
        select.tabIndex = -1;
        select.setAttribute("aria-hidden", "true");

        var activeIndex = -1;

        function optionRows() {
            return Array.prototype.slice.call(menu.querySelectorAll(".ss-option"));
        }

        function visibleOptionRows() {
            return optionRows().filter(function (row) { return !row.hidden; });
        }

        function rebuildMenu() {
            optionRows().forEach(function (row) { row.remove(); });

            Array.prototype.forEach.call(select.options, function (option, index) {
                var row = document.createElement("div");
                row.className = "ss-option";
                row.setAttribute("role", "option");
                row.dataset.value = option.value;
                row.dataset.index = String(index);
                row.textContent = optionDisplayText(option);
                if (option.value === "") {
                    row.classList.add("ss-placeholder");
                }
                menu.insertBefore(row, empty);
            });
        }

        // Text for the blank/placeholder option (e.g. "-- Select Customer --"),
        // if the select has one. Shown via the input's placeholder attribute,
        // never written into its value - see currentOptionText below.
        function blankOptionText() {
            var blank = Array.prototype.filter.call(select.options, function (o) {
                return o.value === "";
            })[0];
            return blank ? optionDisplayText(blank) : "";
        }

        // Empty when nothing is really selected (select.value === ""), even
        // though a placeholder option with that value may have its own text.
        // Keeping this in sync with select.value is what makes the native
        // "required" constraint on the input agree with the real select.
        function currentOptionText() {
            if (select.value === "") { return ""; }
            var selected = select.options[select.selectedIndex];
            return selected ? optionDisplayText(selected) : "";
        }

        function syncFromSelect() {
            rebuildMenu();
            input.placeholder = blankOptionText();
            input.value = currentOptionText();
            input.disabled = select.disabled;
            // Selects without ASP.NET's unobtrusive validation (data-val
            // attributes) rely on the native "required" constraint instead;
            // mirroring it here means the browser's validation bubble on
            // submit anchors to this visible input (first in DOM order)
            // rather than the real select, which is now visually hidden.
            input.required = select.required;
            markSelected();
        }

        function markSelected() {
            optionRows().forEach(function (row) {
                row.classList.toggle("ss-selected", row.dataset.value === select.value);
            });
        }

        function setActive(index) {
            var rows = visibleOptionRows();
            optionRows().forEach(function (row) { row.classList.remove("ss-active"); });
            activeIndex = index;
            if (index >= 0 && index < rows.length) {
                rows[index].classList.add("ss-active");
                rows[index].scrollIntoView({ block: "nearest" });
            }
        }

        function filter(term) {
            var needle = term.trim().toLowerCase();
            var rows = optionRows();
            var anyVisible = false;
            rows.forEach(function (row) {
                var match = needle === "" || row.textContent.toLowerCase().indexOf(needle) !== -1;
                row.hidden = !match;
                if (match) { anyVisible = true; }
            });
            empty.hidden = anyVisible;
            setActive(anyVisible ? 0 : -1);
        }

        function openMenu() {
            if (select.disabled) { return; }
            menu.hidden = false;
            input.setAttribute("aria-expanded", "true");
            filter(input.value);
        }

        function closeMenu(revert) {
            menu.hidden = true;
            input.setAttribute("aria-expanded", "false");
            setActive(-1);
            if (revert) {
                input.value = currentOptionText();
            }
        }

        function commit(row) {
            if (!row) { return; }
            select.value = row.dataset.value;
            input.value = currentOptionText();
            markSelected();
            closeMenu(false);
            $(select).trigger("change");
        }

        // Pure search-bar behavior: typing is what reveals matches, not
        // focusing or clicking into an empty field - there is no "browse
        // the full list" dropdown to open.
        input.addEventListener("focus", function () {
            input.select();
        });

        input.addEventListener("input", function () {
            if (input.value.trim() === "") {
                closeMenu(false);
            } else {
                openMenu();
            }
        });

        input.addEventListener("keydown", function (e) {
            var rows;
            if (e.key === "ArrowDown") {
                if (menu.hidden) { return; }
                e.preventDefault();
                rows = visibleOptionRows();
                setActive(Math.min(activeIndex + 1, rows.length - 1));
            } else if (e.key === "ArrowUp") {
                if (menu.hidden) { return; }
                e.preventDefault();
                setActive(Math.max(activeIndex - 1, 0));
            } else if (e.key === "Enter") {
                if (!menu.hidden) {
                    e.preventDefault();
                    rows = visibleOptionRows();
                    commit(rows[activeIndex] || rows[0]);
                }
            } else if (e.key === "Escape") {
                if (!menu.hidden) {
                    e.preventDefault();
                    closeMenu(true);
                }
            } else if (e.key === "Tab") {
                closeMenu(true);
            }
        });

        input.addEventListener("blur", function () {
            // Let a click on a menu row register before we close/revert.
            setTimeout(function () {
                if (!wrap.contains(document.activeElement)) {
                    closeMenu(true);
                }
            }, 150);
        });

        menu.addEventListener("mousedown", function (e) {
            var row = e.target.closest(".ss-option");
            if (row) {
                e.preventDefault();
                commit(row);
            }
        });

        document.addEventListener("click", function (e) {
            if (!wrap.contains(e.target)) {
                closeMenu(true);
            }
        });

        var observer = new MutationObserver(function () {
            syncFromSelect();
            input.classList.toggle("ss-invalid", select.classList.contains("input-validation-error"));
        });
        observer.observe(select, { childList: true, attributes: true, attributeFilter: ["disabled", "class", "required"] });

        syncFromSelect();
    }

    function scan(root) {
        if (!root || !root.querySelectorAll) { return; }
        if (root.matches && root.matches("select[data-searchable]")) {
            initOne(root);
        }
        root.querySelectorAll("select[data-searchable]").forEach(initOne);
    }

    document.addEventListener("DOMContentLoaded", function () {
        scan(document);

        var bodyObserver = new MutationObserver(function (mutations) {
            mutations.forEach(function (m) {
                m.addedNodes.forEach(function (node) {
                    if (node.nodeType === 1) { scan(node); }
                });
            });
        });
        bodyObserver.observe(document.body, { childList: true, subtree: true });
    });
})();
