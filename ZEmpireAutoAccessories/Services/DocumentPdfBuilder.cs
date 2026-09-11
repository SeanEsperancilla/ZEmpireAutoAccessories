using QuestPDF.Fluent;
using QuestPDF.Helpers;
using QuestPDF.Infrastructure;
using ZEmpireAutoAccessories.Models;

namespace ZEmpireAutoAccessories.Services
{
    /// <summary>
    /// Builds a single printable document (quotation, receipt, service
    /// invoice, or job order) for one customer's record - distinct from
    /// ReportPdfBuilder, which renders multi-row report listings.
    /// </summary>
    public static class DocumentPdfBuilder
    {
        private static readonly string BrandRed = "#e5464d";

        public static byte[] BuildQuotationPdf(Quotation quotation)
        {
            return Document.Create(container =>
            {
                container.Page(page =>
                {
                    ConfigurePage(page);
                    page.Header().Element(c => ComposeDocHeader(c, "QUOTATION", quotation.QuotationNumber,
                        quotation.QuotationDate, quotation.Status));

                    page.Content().Column(column =>
                    {
                        column.Spacing(10);

                        column.Item().Row(row =>
                        {
                            row.RelativeItem().Element(c => BillTo(c, quotation.Customer.FullName, quotation.Customer.ContactNumber,
                                quotation.Vehicle.PlateNumber, quotation.Vehicle.Brand, quotation.Vehicle.Model));

                            row.RelativeItem().Column(col =>
                            {
                                col.Item().Text("Details").FontSize(9).SemiBold().FontColor(Colors.Grey.Darken1);
                                if (quotation.JobType != null)
                                    KeyValue(col, "Job Type", quotation.JobType.JobTypeName);
                                if (quotation.ValidUntil.HasValue)
                                    KeyValue(col, "Valid Until", quotation.ValidUntil.Value.ToString("MMM d, yyyy"));
                                KeyValue(col, "Prepared By", quotation.User.FullName);
                            });
                        });

                        ComposeLineItemsTable(column, quotation.Details.Select(d => (
                            Description: d.Product?.ProductName ?? d.Service?.ServiceName ?? d.Description ?? "—",
                            Note: d.Product == null && d.Service == null ? null : d.Description,
                            Qty: (decimal)d.Quantity,
                            Unit: d.Unit,
                            UnitPrice: d.UnitPrice,
                            Discount: (decimal?)null,
                            SubTotal: d.SubTotal
                        )), includeDiscountColumn: false);

                        ComposeTotals(column, ("Sub Total", quotation.SubTotal), ("Discount", -quotation.DiscountAmount),
                            ("Tax", quotation.TaxAmount), ("Total", quotation.TotalAmount));

                        if (!string.IsNullOrWhiteSpace(quotation.Remarks))
                            ComposeRemarks(column, quotation.Remarks);
                    });

                    page.Footer().Element(c => ComposeFooter(c, "This quotation is an estimate and does not constitute a final invoice."));
                });
            }).GeneratePdf();
        }

        public static byte[] BuildSalePdf(Sale sale)
        {
            return Document.Create(container =>
            {
                container.Page(page =>
                {
                    ConfigurePage(page);
                    page.Header().Element(c => ComposeDocHeader(c, "SALES RECEIPT", sale.InvoiceNumber, sale.SalesDate, null));

                    page.Content().Column(column =>
                    {
                        column.Spacing(10);

                        column.Item().Row(row =>
                        {
                            row.RelativeItem().Element(c => BillTo(c, sale.Customer.FullName, sale.Customer.ContactNumber,
                                sale.Vehicle?.PlateNumber, sale.Vehicle?.Brand, sale.Vehicle?.Model));

                            row.RelativeItem().Column(col =>
                            {
                                col.Item().Text("Details").FontSize(9).SemiBold().FontColor(Colors.Grey.Darken1);
                                KeyValue(col, "Payment Mode", sale.PaymentMode.PaymentModeName);
                                KeyValue(col, "Sold By", sale.User.FullName);
                            });
                        });

                        ComposeLineItemsTable(column, sale.SaleDetails.Select(d => (
                            Description: (string?)d.Product.ProductName,
                            Note: (string?)null,
                            Qty: (decimal)d.Quantity,
                            Unit: "Unit",
                            UnitPrice: d.UnitPrice,
                            Discount: (decimal?)null,
                            SubTotal: d.SubTotal
                        )), includeDiscountColumn: false, includeUnitColumn: false);

                        ComposeTotals(column, ("Total", sale.TotalAmount));
                    });

                    page.Footer().Element(c => ComposeFooter(c, "Thank you for your business!"));
                });
            }).GeneratePdf();
        }

        public static byte[] BuildServiceInvoicePdf(ServiceInvoice invoice)
        {
            return Document.Create(container =>
            {
                container.Page(page =>
                {
                    ConfigurePage(page);
                    page.Header().Element(c => ComposeDocHeader(c, "SERVICE INVOICE", invoice.InvoiceNumber, invoice.InvoiceDate, invoice.Status));

                    page.Content().Column(column =>
                    {
                        column.Spacing(10);

                        column.Item().Row(row =>
                        {
                            row.RelativeItem().Element(c => BillTo(c, invoice.Customer.FullName, invoice.Customer.ContactNumber,
                                invoice.Vehicle?.PlateNumber, invoice.Vehicle?.Brand, invoice.Vehicle?.Model));

                            row.RelativeItem().Column(col =>
                            {
                                col.Item().Text("Details").FontSize(9).SemiBold().FontColor(Colors.Grey.Darken1);
                                if (invoice.JobOrder != null)
                                    KeyValue(col, "Job Order", invoice.JobOrder.JobOrderNumber);
                                KeyValue(col, "Payment Mode", invoice.PaymentMode.PaymentModeName);
                                KeyValue(col, "Processed By", invoice.User.FullName);
                            });
                        });

                        ComposeLineItemsTable(column, invoice.Details.Select(d => (
                            Description: (string?)(d.Product?.ProductName ?? d.Service?.ServiceName ?? d.Description),
                            Note: d.Product == null && d.Service == null ? null : d.Description,
                            Qty: d.Quantity,
                            Unit: d.Unit,
                            UnitPrice: d.UnitPrice,
                            Discount: (decimal?)d.DiscountAmount,
                            SubTotal: d.SubTotal
                        )), includeDiscountColumn: true);

                        ComposeTotals(column,
                            ("Sub Total", invoice.SubTotal),
                            ("Discount", -invoice.DiscountAmount),
                            ("Tax", invoice.TaxAmount),
                            ("Total", invoice.TotalAmount),
                            ("Amount Paid", invoice.AmountPaid),
                            ("Change", invoice.ChangeAmount));

                        if (!string.IsNullOrWhiteSpace(invoice.Remarks))
                            ComposeRemarks(column, invoice.Remarks);
                    });

                    page.Footer().Element(c => ComposeFooter(c, "Thank you for choosing Z-Empire Auto Accessories!"));
                });
            }).GeneratePdf();
        }

        public static byte[] BuildJobOrderPdf(JobOrder jobOrder)
        {
            var total = jobOrder.Details.Sum(d => d.SubTotal);

            return Document.Create(container =>
            {
                container.Page(page =>
                {
                    ConfigurePage(page);
                    page.Header().Element(c => ComposeDocHeader(c, "JOB ORDER", jobOrder.JobOrderNumber, jobOrder.JobOrderDate, jobOrder.Status));

                    page.Content().Column(column =>
                    {
                        column.Spacing(10);

                        column.Item().Row(row =>
                        {
                            row.RelativeItem().Element(c => BillTo(c, jobOrder.Customer.FullName, jobOrder.Customer.ContactNumber,
                                jobOrder.Vehicle.PlateNumber, jobOrder.Vehicle.Brand, jobOrder.Vehicle.Model));

                            row.RelativeItem().Column(col =>
                            {
                                col.Item().Text("Details").FontSize(9).SemiBold().FontColor(Colors.Grey.Darken1);
                                if (jobOrder.JobType != null)
                                    KeyValue(col, "Job Type", jobOrder.JobType.JobTypeName);
                                KeyValue(col, "Technician", jobOrder.AssignedEmployee != null
                                    ? $"{jobOrder.AssignedEmployee.FirstName} {jobOrder.AssignedEmployee.LastName}" : "Unassigned");
                                if (jobOrder.InstallationDate.HasValue)
                                    KeyValue(col, "Installation Date", jobOrder.InstallationDate.Value.ToString("MMM d, yyyy"));
                                if (jobOrder.Odometer.HasValue)
                                    KeyValue(col, "Odometer", $"{jobOrder.Odometer} km");
                            });
                        });

                        if (!string.IsNullOrWhiteSpace(jobOrder.Complaint) || !string.IsNullOrWhiteSpace(jobOrder.ReasonForChanging)
                            || !string.IsNullOrWhiteSpace(jobOrder.ExistingFilmShade) || !string.IsNullOrWhiteSpace(jobOrder.SpecialInstruction))
                        {
                            column.Item().Border(1).BorderColor(Colors.Grey.Lighten2).Padding(8).Column(col =>
                            {
                                if (!string.IsNullOrWhiteSpace(jobOrder.Complaint))
                                    KeyValue(col, "Complaint", jobOrder.Complaint);
                                if (!string.IsNullOrWhiteSpace(jobOrder.ExistingFilmShade))
                                    KeyValue(col, "Existing Film Shade", jobOrder.ExistingFilmShade);
                                if (!string.IsNullOrWhiteSpace(jobOrder.ReasonForChanging))
                                    KeyValue(col, "Reason for Changing", jobOrder.ReasonForChanging);
                                if (!string.IsNullOrWhiteSpace(jobOrder.SpecialInstruction))
                                    KeyValue(col, "Special Instruction", jobOrder.SpecialInstruction);
                            });
                        }

                        ComposeLineItemsTable(column, jobOrder.Details.Select(d => (
                            Description: (string?)(d.Product?.ProductName ?? d.Service?.ServiceName ?? d.Description),
                            Note: d.Product == null && d.Service == null ? null : d.Description,
                            Qty: (decimal)d.Quantity,
                            Unit: d.Unit,
                            UnitPrice: d.UnitPrice,
                            Discount: (decimal?)null,
                            SubTotal: d.SubTotal
                        )), includeDiscountColumn: false);

                        ComposeTotals(column, ("Total", total));

                        column.Item().PaddingTop(24).Row(row =>
                        {
                            row.RelativeItem().Column(col =>
                            {
                                col.Item().LineHorizontal(1).LineColor(Colors.Grey.Lighten1);
                                col.Item().PaddingTop(3).Text("Customer Signature").FontSize(8).FontColor(Colors.Grey.Medium);
                            });
                            row.ConstantItem(30);
                            row.RelativeItem().Column(col =>
                            {
                                col.Item().LineHorizontal(1).LineColor(Colors.Grey.Lighten1);
                                col.Item().PaddingTop(3).Text("Technician Signature").FontSize(8).FontColor(Colors.Grey.Medium);
                            });
                        });
                    });

                    page.Footer().Element(c => ComposeFooter(c, null));
                });
            }).GeneratePdf();
        }

        private static void ConfigurePage(PageDescriptor page)
        {
            page.Size(PageSizes.A4);
            page.Margin(32);
            page.DefaultTextStyle(x => x.FontSize(9.5f));
        }

        private static void ComposeDocHeader(IContainer container, string docType, string docNumber, DateTime docDate, string? status)
        {
            container.Column(column =>
            {
                column.Item().Row(row =>
                {
                    row.RelativeItem().Column(col =>
                    {
                        col.Item().Text("Z-Empire Auto Accessories").FontSize(16).Bold();
                        col.Item().Text("Auto Tint & Accessories Shop").FontSize(8).FontColor(Colors.Grey.Medium);
                    });

                    row.ConstantItem(180).Column(col =>
                    {
                        col.Item().AlignRight().Text(docType).FontSize(14).Bold().FontColor(BrandRed);
                        col.Item().AlignRight().Text($"No. {docNumber}").FontSize(9).SemiBold();
                        col.Item().AlignRight().Text(docDate.ToString("MMM d, yyyy")).FontSize(8).FontColor(Colors.Grey.Medium);
                        if (!string.IsNullOrEmpty(status))
                            col.Item().AlignRight().Text(status).FontSize(8).FontColor(BrandRed).SemiBold();
                    });
                });

                column.Item().PaddingTop(8).PaddingBottom(6).LineHorizontal(1).LineColor(Colors.Grey.Lighten2);
            });
        }

        private static void BillTo(IContainer container, string customerName, string? contactNumber,
            string? plateNumber, string? brand, string? model)
        {
            container.Column(col =>
            {
                col.Item().Text("Bill To").FontSize(9).SemiBold().FontColor(Colors.Grey.Darken1);
                col.Item().Text(customerName).FontSize(11).Bold();
                if (!string.IsNullOrEmpty(contactNumber))
                    col.Item().Text(contactNumber).FontSize(9).FontColor(Colors.Grey.Darken1);

                if (!string.IsNullOrEmpty(plateNumber) || !string.IsNullOrEmpty(brand))
                {
                    var vehicleLine = string.Join(" — ", new[] { plateNumber, $"{brand} {model}".Trim() }
                        .Where(s => !string.IsNullOrWhiteSpace(s)));
                    col.Item().PaddingTop(2).Text(vehicleLine).FontSize(9).FontColor(Colors.Grey.Darken1);
                }
            });
        }

        private static void KeyValue(ColumnDescriptor column, string key, string? value)
        {
            column.Item().PaddingTop(1).Row(row =>
            {
                row.ConstantItem(90).Text(key).FontSize(8.5f).FontColor(Colors.Grey.Medium);
                row.RelativeItem().Text(value ?? "—").FontSize(9);
            });
        }

        private static void ComposeLineItemsTable(
            ColumnDescriptor column,
            IEnumerable<(string? Description, string? Note, decimal Qty, string Unit, decimal UnitPrice, decimal? Discount, decimal SubTotal)> lines,
            bool includeDiscountColumn,
            bool includeUnitColumn = true)
        {
            var lineList = lines.ToList();

            column.Item().Table(table =>
            {
                table.ColumnsDefinition(columns =>
                {
                    columns.RelativeColumn(4);
                    columns.RelativeColumn(1.3f);
                    if (includeUnitColumn)
                        columns.RelativeColumn(1.3f);
                    columns.RelativeColumn(1.8f);
                    if (includeDiscountColumn)
                        columns.RelativeColumn(1.5f);
                    columns.RelativeColumn(1.8f);
                });

                table.Header(header =>
                {
                    header.Cell().Element(HeaderCell).Text("Description");
                    header.Cell().Element(HeaderCell).AlignRight().Text("Qty");
                    if (includeUnitColumn)
                        header.Cell().Element(HeaderCell).Text("Unit");
                    header.Cell().Element(HeaderCell).AlignRight().Text("Unit Price");
                    if (includeDiscountColumn)
                        header.Cell().Element(HeaderCell).AlignRight().Text("Discount");
                    header.Cell().Element(HeaderCell).AlignRight().Text("Sub Total");
                });

                foreach (var line in lineList)
                {
                    table.Cell().Element(BodyCell).Column(col =>
                    {
                        col.Item().Text(line.Description ?? "—");
                        if (!string.IsNullOrWhiteSpace(line.Note))
                            col.Item().Text(line.Note).FontSize(8).FontColor(Colors.Grey.Medium);
                    });
                    table.Cell().Element(BodyCell).AlignRight().Text(line.Qty.ToString("0.##"));
                    if (includeUnitColumn)
                        table.Cell().Element(BodyCell).Text(line.Unit);
                    table.Cell().Element(BodyCell).AlignRight().Text("₱" + line.UnitPrice.ToString("N2"));
                    if (includeDiscountColumn)
                        table.Cell().Element(BodyCell).AlignRight().Text("₱" + (line.Discount ?? 0).ToString("N2"));
                    table.Cell().Element(BodyCell).AlignRight().Text("₱" + line.SubTotal.ToString("N2"));
                }

                if (lineList.Count == 0)
                {
                    var columnCount = 3 + (includeUnitColumn ? 1 : 0) + (includeDiscountColumn ? 1 : 0);
                    table.Cell().ColumnSpan((uint)columnCount).Element(BodyCell).AlignCenter()
                        .Text("No line items.").FontColor(Colors.Grey.Medium);
                }
            });
        }

        private static void ComposeTotals(ColumnDescriptor column, params (string Label, decimal Value)[] rows)
        {
            column.Item().AlignRight().Width(220).Column(col =>
            {
                for (var i = 0; i < rows.Length; i++)
                {
                    var (label, value) = rows[i];
                    var isTotal = i == rows.Length - 1 && rows.Length > 1 && label == "Total";
                    var isLast = i == rows.Length - 1;

                    col.Item().Row(row =>
                    {
                        var labelText = row.RelativeItem().Text(label).FontSize(isTotal ? 10.5f : 9);
                        if (isTotal)
                            labelText.SemiBold();

                        var valueText = row.ConstantItem(110).AlignRight()
                            .Text(value < 0 ? "-₱" + Math.Abs(value).ToString("N2") : "₱" + value.ToString("N2"))
                            .FontSize(isTotal ? 11 : 9);
                        if (isTotal || isLast)
                            valueText.SemiBold();
                    });

                    if (isTotal)
                        col.Item().PaddingTop(2).LineHorizontal(1).LineColor(Colors.Grey.Lighten1);
                }
            });
        }

        private static void ComposeRemarks(ColumnDescriptor column, string remarks)
        {
            column.Item().PaddingTop(4).Column(col =>
            {
                col.Item().Text("Remarks").FontSize(9).SemiBold().FontColor(Colors.Grey.Darken1);
                col.Item().Text(remarks).FontSize(9);
            });
        }

        private static void ComposeFooter(IContainer container, string? note)
        {
            container.Column(column =>
            {
                if (!string.IsNullOrEmpty(note))
                    column.Item().AlignCenter().Text(note).FontSize(8).Italic().FontColor(Colors.Grey.Medium);

                column.Item().AlignCenter().Text(text =>
                {
                    text.DefaultTextStyle(x => x.FontSize(7.5f).FontColor(Colors.Grey.Medium));
                    text.Span($"Generated {DateTime.Now:MMM d, yyyy h:mm tt} · Page ");
                    text.CurrentPageNumber();
                    text.Span(" of ");
                    text.TotalPages();
                });
            });
        }

        private static IContainer HeaderCell(IContainer container) =>
            container.Background(Colors.Black).DefaultTextStyle(x => x.FontColor(Colors.White).SemiBold())
                .PaddingVertical(5).PaddingHorizontal(4);

        private static IContainer BodyCell(IContainer container) =>
            container.BorderBottom(1).BorderColor(Colors.Grey.Lighten2).PaddingVertical(4).PaddingHorizontal(4);
    }
}
