using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ZEmpireAutoAccessories.Authorization;
using ZEmpireAutoAccessories.Data;
using ZEmpireAutoAccessories.Models;

namespace ZEmpireAutoAccessories.Controllers
{
    [ModuleAuthorize("Customers")]
    public class CustomerController : Controller
    {
        private readonly ApplicationDbContext _context;

        public CustomerController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: Customer
        public async Task<IActionResult> Index()
        {
            var customers = await _context.Customers
                .OrderBy(c => c.FullName)
                .ToListAsync();

            return View(customers);
        }

        // GET: Customer/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
                return NotFound();

            var customer = await _context.Customers
                .Include(c => c.Vehicles)
                .FirstOrDefaultAsync(c =>
                    c.CustomerID == id);

            if (customer == null)
                return NotFound();

            return View(customer);
        }

        // GET: Customer/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: Customer/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(Customer customer)
        {
            if (!ModelState.IsValid)
                return View(customer);

            customer.CreatedAt = DateTime.UtcNow;

            _context.Customers.Add(customer);
            await _context.SaveChangesAsync();

            return RedirectToAction(nameof(Index));
        }

        // GET: Customer/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
                return NotFound();

            var customer =
                await _context.Customers.FindAsync(id);

            if (customer == null)
                return NotFound();

            return View(customer);
        }

        // POST: Customer/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(
            int id,
            Customer customer)
        {
            if (id != customer.CustomerID)
                return NotFound();

            if (!ModelState.IsValid)
                return View(customer);

            try
            {
                _context.Update(customer);
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!CustomerExists(customer.CustomerID))
                    return NotFound();

                throw;
            }

            return RedirectToAction(nameof(Index));
        }

        // GET: Customer/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
                return NotFound();

            var customer = await _context.Customers
                .Include(c => c.Vehicles)
                .FirstOrDefaultAsync(c =>
                    c.CustomerID == id);

            if (customer == null)
                return NotFound();

            return View(customer);
        }

        // POST: Customer/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var customer = await _context.Customers
                .Include(c => c.Vehicles)
                .FirstOrDefaultAsync(c =>
                    c.CustomerID == id);

            if (customer == null)
                return RedirectToAction(nameof(Index));

            if (customer.Vehicles.Count > 0)
            {
                var word = customer.Vehicles.Count == 1 ? "vehicle" : "vehicles";
                TempData["DeleteError"] =
                    $"Can't delete this customer. They still have {customer.Vehicles.Count} {word} registered. " +
                    $"Remove or reassign the {word} first.";

                return RedirectToAction(nameof(Delete), new { id });
            }

            try
            {
                _context.Customers.Remove(customer);
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                TempData["DeleteError"] =
                    "Can't delete this customer. They still have related records " +
                    "(sales, job orders, quotations, or invoices) elsewhere in the system. " +
                    "Remove or reassign those first.";

                return RedirectToAction(nameof(Delete), new { id });
            }

            return RedirectToAction(nameof(Index));
        }

        private bool CustomerExists(int id)
        {
            return _context.Customers
                .Any(c => c.CustomerID == id);
        }
    }
}