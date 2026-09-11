using QuestPDF.Fluent;
using QuestPDF.Helpers;
using QuestPDF.Infrastructure;
using ZEmpireAutoAccessories.Models;

namespace ZEmpireAutoAccessories.Services
{
    /// <summary>
    /// Builds the downloadable PDF versions of the Sales, Quotation and Job
    /// Order reports using QuestPDF. Pure formatting - all filtering/totals
    /// are computed by ReportController before the data reaches here.
    /// </summary>
    public static class ReportPdfBuilder
    {
        private static readonly string BrandRed = "#e5464d";

        public static byte[] BuildSalesPdf(List<VwSalesSummary> items, DateOnly? from, DateOnly? to, decimal total)
        {
            return Document.Create(container =>
            {
                container.Page(page =>
                {
                    ConfigurePage(page);
                    page.Header().Element(c => ComposeHeader(c, "Sales Report", BuildRangeSubtitle(from, to, null)));

                    page.Content().Column(column =>
                    {
                        column.Spacing(6);

                        column.Item().Table(table =>
                        {
                            table.ColumnsDefinition(columns =>
                            {
                                columns.RelativeColumn(2);
                                columns.RelativeColumn(2);
                                columns.RelativeColumn(3);
                                columns.RelativeColumn(2.5f);
                                columns.RelativeColumn(2);
                                columns.RelativeColumn(2);
                            });

                            table.Header(header =>
                            {
                                header.Cell().Element(HeaderCell).Text("Invoice #");
                                header.Cell().Element(HeaderCell).Text("Date");
                                header.Cell().Element(HeaderCell).Text("Customer");
                                header.Cell().Element(HeaderCell).Text("Payment Mode");
                                header.Cell().Element(HeaderCell).Text("Sold By");
                                header.Cell().Element(HeaderCell).AlignRight().Text("Total");
                            });

                            foreach (var item in items)
                            {
                                table.Cell().Element(BodyCell).Text(item.InvoiceNumber);
                                table.Cell().Element(BodyCell).Text(item.SalesDate.ToString("MMM d, yyyy"));
                                table.Cell().Element(BodyCell).Text(item.CustomerName);
                                table.Cell().Element(BodyCell).Text(item.PaymentModeName);
                                table.Cell().Element(BodyCell).Text(item.SoldBy);
                                table.Cell().Element(BodyCell).AlignRight().Text("₱" + item.RecordedTotal.ToString("N2"));
                            }
                        });

                        ComposeEmptyOrTotal(column, items.Count, "No sales found for this range.", total);
                    });

                    page.Footer().Element(ComposeFooter);
                });
            }).GeneratePdf();
        }

        public static byte[] BuildQuotationsPdf(List<VwQuotationSummary> items, DateOnly? from, DateOnly? to, string? status, decimal total)
        {
            return Document.Create(container =>
            {
                container.Page(page =>
                {
                    ConfigurePage(page);
                    page.Header().Element(c => ComposeHeader(c, "Quotations Report", BuildRangeSubtitle(from, to, status)));

                    page.Content().Column(column =>
                    {
                        column.Spacing(6);

                        column.Item().Table(table =>
                        {
                            table.ColumnsDefinition(columns =>
                            {
                                columns.RelativeColumn(2);
                                columns.RelativeColumn(2);
                                columns.RelativeColumn(3);
                                columns.RelativeColumn(1.6f);
                                columns.RelativeColumn(2);
                                columns.RelativeColumn(2.2f);
                                columns.RelativeColumn(2);
                            });

                            table.Header(header =>
                            {
                                header.Cell().Element(HeaderCell).Text("Number");
                                header.Cell().Element(HeaderCell).Text("Date");
                                header.Cell().Element(HeaderCell).Text("Customer");
                                header.Cell().Element(HeaderCell).Text("Status");
                                header.Cell().Element(HeaderCell).Text("Converted To");
                                header.Cell().Element(HeaderCell).Text("Prepared By");
                                header.Cell().Element(HeaderCell).AlignRight().Text("Total");
                            });

                            foreach (var item in items)
                            {
                                table.Cell().Element(BodyCell).Text(item.QuotationNumber);
                                table.Cell().Element(BodyCell).Text(item.QuotationDate.ToString("MMM d, yyyy"));
                                table.Cell().Element(BodyCell).Text(item.CustomerName);
                                table.Cell().Element(BodyCell).Text(item.Status);
                                table.Cell().Element(BodyCell).Text(item.ConvertedJobOrderNumber ?? "—");
                                table.Cell().Element(BodyCell).Text(item.PreparedBy);
                                table.Cell().Element(BodyCell).AlignRight().Text("₱" + item.TotalAmount.ToString("N2"));
                            }
                        });

                        ComposeEmptyOrTotal(column, items.Count, "No quotations found for this range.", total);
                    });

                    page.Footer().Element(ComposeFooter);
                });
            }).GeneratePdf();
        }

        public static byte[] BuildJobOrdersPdf(List<VwJobOrderSummary> items, DateOnly? from, DateOnly? to, string? status, decimal total)
        {
            return Document.Create(container =>
            {
                container.Page(page =>
                {
                    ConfigurePage(page);
                    page.Header().Element(c => ComposeHeader(c, "Job Orders Report", BuildRangeSubtitle(from, to, status)));

                    page.Content().Column(column =>
                    {
                        column.Spacing(6);

                        column.Item().Table(table =>
                        {
                            table.ColumnsDefinition(columns =>
                            {
                                columns.RelativeColumn(2);
                                columns.RelativeColumn(2);
                                columns.RelativeColumn(3);
                                columns.RelativeColumn(2);
                                columns.RelativeColumn(1.6f);
                                columns.RelativeColumn(2.2f);
                                columns.RelativeColumn(1);
                                columns.RelativeColumn(2);
                            });

                            table.Header(header =>
                            {
                                header.Cell().Element(HeaderCell).Text("Number");
                                header.Cell().Element(HeaderCell).Text("Date");
                                header.Cell().Element(HeaderCell).Text("Customer");
                                header.Cell().Element(HeaderCell).Text("Job Type");
                                header.Cell().Element(HeaderCell).Text("Status");
                                header.Cell().Element(HeaderCell).Text("Handled By");
                                header.Cell().Element(HeaderCell).AlignRight().Text("Lines");
                                header.Cell().Element(HeaderCell).AlignRight().Text("Total");
                            });

                            foreach (var item in items)
                            {
                                table.Cell().Element(BodyCell).Text(item.JobOrderNumber);
                                table.Cell().Element(BodyCell).Text(item.JobOrderDate.ToString("MMM d, yyyy"));
                                table.Cell().Element(BodyCell).Text(item.CustomerName);
                                table.Cell().Element(BodyCell).Text(item.JobTypeName ?? "—");
                                table.Cell().Element(BodyCell).Text(item.Status);
                                table.Cell().Element(BodyCell).Text(item.HandledBy);
                                table.Cell().Element(BodyCell).AlignRight().Text(item.LineCount.ToString());
                                table.Cell().Element(BodyCell).AlignRight().Text("₱" + item.TotalAmount.ToString("N2"));
                            }
                        });

                        ComposeEmptyOrTotal(column, items.Count, "No job orders found for this range.", total);
                    });

                    page.Footer().Element(ComposeFooter);
                });
            }).GeneratePdf();
        }

        private static void ConfigurePage(PageDescriptor page)
        {
            page.Size(PageSizes.A4);
            page.Margin(30);
            page.DefaultTextStyle(x => x.FontSize(9));
        }

        private static void ComposeHeader(IContainer container, string title, string subtitle)
        {
            container.Column(column =>
            {
                column.Item().Row(row =>
                {
                    row.RelativeItem().Column(col =>
                    {
                        col.Item().Text("Z-Empire Auto Accessories").FontSize(15).Bold();
                        col.Item().Text(title).FontSize(12).SemiBold().FontColor(BrandRed);
                        if (!string.IsNullOrEmpty(subtitle))
                            col.Item().PaddingTop(2).Text(subtitle).FontSize(8).FontColor(Colors.Grey.Darken1);
                    });

                    row.ConstantItem(140).AlignRight().Text($"Generated {DateTime.Now:MMM d, yyyy h:mm tt}")
                        .FontSize(7).FontColor(Colors.Grey.Medium);
                });

                column.Item().PaddingTop(8).PaddingBottom(4).LineHorizontal(1).LineColor(Colors.Grey.Lighten2);
            });
        }

        private static void ComposeFooter(IContainer container)
        {
            container.AlignCenter().Text(text =>
            {
                text.DefaultTextStyle(x => x.FontSize(8).FontColor(Colors.Grey.Medium));
                text.Span("Page ");
                text.CurrentPageNumber();
                text.Span(" of ");
                text.TotalPages();
            });
        }

        private static void ComposeEmptyOrTotal(ColumnDescriptor column, int itemCount, string emptyMessage, decimal total)
        {
            if (itemCount == 0)
            {
                column.Item().PaddingTop(10).AlignCenter().Text(emptyMessage).FontColor(Colors.Grey.Medium);
                return;
            }

            column.Item().PaddingTop(4).LineHorizontal(1).LineColor(Colors.Grey.Lighten2);
            column.Item().AlignRight().Text($"Total: ₱{total:N2}").Bold().FontSize(11);
        }

        private static IContainer HeaderCell(IContainer container) =>
            container.Background(Colors.Black).DefaultTextStyle(x => x.FontColor(Colors.White).SemiBold())
                .PaddingVertical(5).PaddingHorizontal(4);

        private static IContainer BodyCell(IContainer container) =>
            container.BorderBottom(1).BorderColor(Colors.Grey.Lighten2).PaddingVertical(4).PaddingHorizontal(4);

        private static string BuildRangeSubtitle(DateOnly? from, DateOnly? to, string? status)
        {
            var range = (from, to) switch
            {
                (null, null) => "All dates",
                (not null, null) => $"From {from:MMM d, yyyy}",
                (null, not null) => $"Through {to:MMM d, yyyy}",
                _ => $"{from:MMM d, yyyy} – {to:MMM d, yyyy}"
            };

            return string.IsNullOrEmpty(status) ? range : $"{range} · Status: {status}";
        }
    }
}
