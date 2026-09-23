// Unit picker on the "add line item" forms of Quotation, Job Order and
// Service Invoice.
//
// Paint Protection Film and Window Tint come off a roll and are written in
// cm, inches or metres; everything else is counted. Picking a product swaps
// the unit list to match, so nobody has to remember which products are
// measured. The server converts whatever unit is chosen into the unit stock
// is held in - this only decides what is offered.
(function () {
    var product = document.getElementById('addLineProduct');
    var unit = document.querySelector('select[name="unit"]');
    var quantity = document.querySelector('input[name="quantity"]');
    if (!product || !unit) { return; }

    var LENGTH_UNITS = ['cm', 'in', 'm'];
    var COUNT_UNITS = ['Unit', 'pc', 'set', 'roll'];

    function selectedIsRoll() {
        var option = product.options[product.selectedIndex];
        return !!option && option.dataset.roll === 'true';
    }

    function fill(values, preferred) {
        var previous = unit.value;
        unit.innerHTML = '';

        values.forEach(function (value) {
            var option = document.createElement('option');
            option.value = value;
            option.textContent = value;
            unit.appendChild(option);
        });

        // Keep what was already chosen when it is still on offer, so
        // re-picking the same kind of product doesn't reset it.
        unit.value = values.indexOf(previous) !== -1 ? previous : preferred;
    }

    function apply() {
        var roll = selectedIsRoll();
        fill(roll ? LENGTH_UNITS : COUNT_UNITS, roll ? 'cm' : 'Unit');

        // Quotation and Job Order lines store quantity as a whole number, so
        // a measured length has to be written in a unit that comes out whole
        // - centimetres. Leave the step alone where the column is decimal.
        if (quantity && quantity.step === '1') {
            quantity.title = roll
                ? 'Whole numbers only on this document - measure in cm for part metres'
                : '';
        }
    }

    product.addEventListener('change', apply);
    apply();
})();
