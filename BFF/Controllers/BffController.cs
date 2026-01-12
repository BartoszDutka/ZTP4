using Microsoft.AspNetCore.Mvc;
using MobileBFF.Models;
using MobileBFF.Services;

namespace MobileBFF.Controllers;

/// <summary>
/// Kontroler BFF - jedyny punkt wejścia dla aplikacji mobilnej
/// Agreguje dane z Lab 1 (Produkty) i Lab 3 (Koszyk)
/// </summary>
[ApiController]
[Route("api/v1/bff")]
public class BffController : ControllerBase
{
    private readonly IBffService _bffService;
    private readonly ILogger<BffController> _logger;

    public BffController(IBffService bffService, ILogger<BffController> logger)
    {
        _bffService = bffService;
        _logger = logger;
    }

    #region Products - Agregacja z Lab 1

    /// <summary>
    /// GET /api/v1/bff/products
    /// Pobiera listę wszystkich produktów
    /// </summary>
    [HttpGet("products")]
    public async Task<ActionResult<BffResponse<ProductListDto>>> GetProducts()
    {
        try
        {
            var products = await _bffService.GetProductsAsync();
            return Ok(BffResponse<ProductListDto>.Ok(products));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error fetching products");
            return StatusCode(500, BffResponse<ProductListDto>.Fail("Błąd podczas pobierania produktów", "PRODUCTS_ERROR"));
        }
    }

    /// <summary>
    /// GET /api/v1/bff/products/{id}
    /// Pobiera szczegóły produktu
    /// </summary>
    [HttpGet("products/{id}")]
    public async Task<ActionResult<BffResponse<ProductDto>>> GetProduct(string id)
    {
        try
        {
            var product = await _bffService.GetProductAsync(id);
            
            if (product == null)
            {
                return NotFound(BffResponse<ProductDto>.Fail("Produkt nie został znaleziony", "PRODUCT_NOT_FOUND"));
            }

            return Ok(BffResponse<ProductDto>.Ok(product));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error fetching product {ProductId}", id);
            return StatusCode(500, BffResponse<ProductDto>.Fail("Błąd podczas pobierania produktu", "PRODUCT_ERROR"));
        }
    }

    #endregion

    #region Cart - Agregacja z Lab 3

    /// <summary>
    /// POST /api/v1/bff/carts
    /// Tworzy nowy koszyk
    /// </summary>
    [HttpPost("carts")]
    public async Task<ActionResult<BffResponse<string>>> CreateCart([FromBody] CreateCartRequest request)
    {
        try
        {
            var cartId = await _bffService.CreateCartAsync(request.UserId);
            return Ok(BffResponse<string>.Ok(cartId, "Koszyk został utworzony"));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error creating cart for user {UserId}", request.UserId);
            return StatusCode(500, BffResponse<string>.Fail("Błąd podczas tworzenia koszyka", "CART_CREATE_ERROR"));
        }
    }

    /// <summary>
    /// GET /api/v1/bff/carts/{cartId}
    /// Pobiera koszyk
    /// </summary>
    [HttpGet("carts/{cartId}")]
    public async Task<ActionResult<BffResponse<CartDto>>> GetCart(string cartId)
    {
        try
        {
            var cart = await _bffService.GetCartAsync(cartId);

            if (cart == null)
            {
                return NotFound(BffResponse<CartDto>.Fail("Koszyk nie został znaleziony", "CART_NOT_FOUND"));
            }

            return Ok(BffResponse<CartDto>.Ok(cart));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error fetching cart {CartId}", cartId);
            return StatusCode(500, BffResponse<CartDto>.Fail("Błąd podczas pobierania koszyka", "CART_ERROR"));
        }
    }

    /// <summary>
    /// POST /api/v1/bff/carts/{cartId}/items
    /// Dodaje produkt do koszyka
    /// </summary>
    [HttpPost("carts/{cartId}/items")]
    public async Task<ActionResult<BffResponse<bool>>> AddToCart(string cartId, [FromBody] AddToCartRequest request)
    {
        try
        {
            var success = await _bffService.AddToCartAsync(cartId, request.ProductId, request.Quantity);

            if (!success)
            {
                return BadRequest(BffResponse<bool>.Fail("Nie udało się dodać produktu do koszyka", "ADD_TO_CART_ERROR"));
            }

            return Ok(BffResponse<bool>.Ok(true, "Produkt został dodany do koszyka"));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error adding product {ProductId} to cart {CartId}", request.ProductId, cartId);
            return StatusCode(500, BffResponse<bool>.Fail("Błąd podczas dodawania produktu", "ADD_TO_CART_ERROR"));
        }
    }

    /// <summary>
    /// DELETE /api/v1/bff/carts/{cartId}/items/{productId}
    /// Usuwa produkt z koszyka
    /// </summary>
    [HttpDelete("carts/{cartId}/items/{productId}")]
    public async Task<ActionResult<BffResponse<bool>>> RemoveFromCart(string cartId, string productId, [FromQuery] int? quantity)
    {
        try
        {
            var success = await _bffService.RemoveFromCartAsync(cartId, productId, quantity);

            if (!success)
            {
                return BadRequest(BffResponse<bool>.Fail("Nie udało się usunąć produktu z koszyka", "REMOVE_FROM_CART_ERROR"));
            }

            return Ok(BffResponse<bool>.Ok(true, "Produkt został usunięty z koszyka"));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error removing product {ProductId} from cart {CartId}", productId, cartId);
            return StatusCode(500, BffResponse<bool>.Fail("Błąd podczas usuwania produktu", "REMOVE_FROM_CART_ERROR"));
        }
    }

    #endregion
}
