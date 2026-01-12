using System.Text;
using System.Text.Json;
using MobileBFF.Models;

namespace MobileBFF.Services;

/// <summary>
/// Interfejs serwisu koszyka - proxy do Lab 3
/// </summary>
public interface ICartService
{
    Task<string> CreateCartAsync(string userId);
    Task<CartDto?> GetCartAsync(string cartId);
    Task<bool> AddProductToCartAsync(string cartId, string productId, int quantity);
    Task<bool> RemoveProductFromCartAsync(string cartId, string productId, int? quantity = null);
}

/// <summary>
/// Serwis koszyka - komunikacja z API Lab 3
/// </summary>
public class CartService : ICartService
{
    private readonly HttpClient _httpClient;
    private readonly ILogger<CartService> _logger;
    private readonly JsonSerializerOptions _jsonOptions;

    public CartService(HttpClient httpClient, ILogger<CartService> logger)
    {
        _httpClient = httpClient;
        _logger = logger;
        _jsonOptions = new JsonSerializerOptions
        {
            PropertyNameCaseInsensitive = true,
            PropertyNamingPolicy = JsonNamingPolicy.CamelCase
        };
    }

    public async Task<string> CreateCartAsync(string userId)
    {
        try
        {
            var content = new StringContent(
                JsonSerializer.Serialize(new { userId }, _jsonOptions),
                Encoding.UTF8,
                "application/json");

            var response = await _httpClient.PostAsync("/api/v1/carts", content);
            response.EnsureSuccessStatusCode();

            var result = await response.Content.ReadAsStringAsync();
            // API zwraca GUID jako string
            return result.Trim('"');
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error creating cart for user {UserId}", userId);
            throw;
        }
    }

    public async Task<CartDto?> GetCartAsync(string cartId)
    {
        try
        {
            var response = await _httpClient.GetAsync($"/api/v1/carts/{cartId}");

            if (response.StatusCode == System.Net.HttpStatusCode.NotFound)
            {
                return null;
            }

            response.EnsureSuccessStatusCode();

            var content = await response.Content.ReadAsStringAsync();
            return JsonSerializer.Deserialize<CartDto>(content, _jsonOptions);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error fetching cart {CartId}", cartId);
            throw;
        }
    }

    public async Task<bool> AddProductToCartAsync(string cartId, string productId, int quantity)
    {
        try
        {
            var content = new StringContent(
                JsonSerializer.Serialize(new { productId, quantity }, _jsonOptions),
                Encoding.UTF8,
                "application/json");

            var response = await _httpClient.PostAsync($"/api/v1/carts/{cartId}/items", content);
            return response.IsSuccessStatusCode;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error adding product {ProductId} to cart {CartId}", productId, cartId);
            return false;
        }
    }

    public async Task<bool> RemoveProductFromCartAsync(string cartId, string productId, int? quantity = null)
    {
        try
        {
            var url = $"/api/v1/carts/{cartId}/items/{productId}";
            if (quantity.HasValue)
            {
                url += $"?quantity={quantity.Value}";
            }

            var response = await _httpClient.DeleteAsync(url);
            return response.IsSuccessStatusCode;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error removing product {ProductId} from cart {CartId}", productId, cartId);
            return false;
        }
    }
}
