using MobileBFF.Models;

namespace MobileBFF.Services;

/// <summary>
/// Interfejs agregatora BFF - łączy dane z różnych serwisów
/// </summary>
public interface IBffService
{
    Task<ProductListDto> GetProductsAsync();
    Task<ProductDto?> GetProductAsync(string id);
    Task<string> CreateCartAsync(string userId);
    Task<CartDto?> GetCartAsync(string cartId);
    Task<bool> AddToCartAsync(string cartId, string productId, int quantity);
    Task<bool> RemoveFromCartAsync(string cartId, string productId, int? quantity = null);
}

/// <summary>
/// Serwis BFF - agreguje dane z Lab 1 i Lab 3
/// Transformuje dane do formatu optymalnego dla aplikacji mobilnej
/// </summary>
public class BffService : IBffService
{
    private readonly IProductService _productService;
    private readonly ICartService _cartService;
    private readonly ILogger<BffService> _logger;

    public BffService(
        IProductService productService,
        ICartService cartService,
        ILogger<BffService> logger)
    {
        _productService = productService;
        _cartService = cartService;
        _logger = logger;
    }

    /// <summary>
    /// Pobiera listę produktów z metadanymi
    /// </summary>
    public async Task<ProductListDto> GetProductsAsync()
    {
        var products = await _productService.GetAllProductsAsync();

        return new ProductListDto
        {
            Products = products,
            TotalCount = products.Count
        };
    }

    /// <summary>
    /// Pobiera szczegóły produktu
    /// </summary>
    public async Task<ProductDto?> GetProductAsync(string id)
    {
        return await _productService.GetProductByIdAsync(id);
    }

    /// <summary>
    /// Tworzy nowy koszyk
    /// </summary>
    public async Task<string> CreateCartAsync(string userId)
    {
        return await _cartService.CreateCartAsync(userId);
    }

    /// <summary>
    /// Pobiera koszyk
    /// </summary>
    public async Task<CartDto?> GetCartAsync(string cartId)
    {
        return await _cartService.GetCartAsync(cartId);
    }

    /// <summary>
    /// Dodaje produkt do koszyka
    /// </summary>
    public async Task<bool> AddToCartAsync(string cartId, string productId, int quantity)
    {
        return await _cartService.AddProductToCartAsync(cartId, productId, quantity);
    }

    /// <summary>
    /// Usuwa produkt z koszyka
    /// </summary>
    public async Task<bool> RemoveFromCartAsync(string cartId, string productId, int? quantity = null)
    {
        return await _cartService.RemoveProductFromCartAsync(cartId, productId, quantity);
    }
}
