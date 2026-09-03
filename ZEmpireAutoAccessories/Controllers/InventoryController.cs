using System.Security.Claims;
using Microsoft.AspNetCore.Mvc;
using ZEmpireAutoAccessories.Authorization;
using ZEmpireAutoAccessories.Services.Interfaces;

namespace ZEmpireAutoAccessories.Controllers
{
    [ModuleAuthorize("Inventory")]
    public class InventoryController : Controller
    {
        private readonly IInventoryService _inventoryService;

        public InventoryController(IInventoryService inventoryService)
        {
            _inventoryService = inventoryService;
        }

        public async Task<IActionResult> Index()
        {
            var stockLevels = await _inventoryService.GetStockLevels();
            return View(stockLevels);
        }

        // id = ProductID
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
                return NotFound();

            var product = await _inventoryService.GetProduct(id.Value);
            if (product == null)
                return NotFound();

            ViewData["StockOnHand"] = await _inventoryService.GetStockOnHand(id.Value);
            ViewData["Transactions"] = await _inventoryService.GetTransactions(id.Value);

            return View(product);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> StockIn(int productId, decimal quantity)
        {
            try
            {
                await _inventoryService.StockIn(productId, quantity, CurrentUserId);
                TempData["Success"] = $"Recorded stock-in of {quantity}.";
            }
            catch (Exception ex)
            {
                TempData["InventoryError"] = ex.Message;
            }

            return RedirectToAction(nameof(Details), new { id = productId });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> StockOut(int productId, decimal quantity)
        {
            try
            {
                await _inventoryService.StockOut(productId, quantity, CurrentUserId);
                TempData["Success"] = $"Recorded stock-out of {quantity}.";
            }
            catch (Exception ex)
            {
                TempData["InventoryError"] = ex.Message;
            }

            return RedirectToAction(nameof(Details), new { id = productId });
        }

        private string CurrentUserId =>
            User.FindFirstValue(ClaimTypes.NameIdentifier)!;
    }
}