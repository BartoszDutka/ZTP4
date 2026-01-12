using System.Text.Json;
using MobileBFF.Models;

namespace MobileBFF.Services;

/// <summary>
/// Interfejs serwisu produktów - proxy do Lab 1
/// </summary>
public interface IProductService
{
    Task<List<ProductDto>> GetAllProductsAsync();
    Task<ProductDto?> GetProductByIdAsync(string id);
}

/// <summary>
/// Serwis produktów - komunikacja z API Lab 1
/// </summary>
public class ProductService : IProductService
{
    private readonly HttpClient _httpClient;
    private readonly ILogger<ProductService> _logger;
    private readonly JsonSerializerOptions _jsonOptions;

    public ProductService(HttpClient httpClient, ILogger<ProductService> logger)
    {
        _httpClient = httpClient;
        _logger = logger;
        _jsonOptions = new JsonSerializerOptions
        {
            PropertyNameCaseInsensitive = true
        };
    }

    public async Task<List<ProductDto>> GetAllProductsAsync()
    {
        try
        {
            var response = await _httpClient.GetAsync("/api/v1/products");
            response.EnsureSuccessStatusCode();

            var content = await response.Content.ReadAsStringAsync();
            var apiResponse = JsonSerializer.Deserialize<Lab1Response<List<ProductDto>>>(content, _jsonOptions);

            return apiResponse?.Data ?? new List<ProductDto>();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error fetching products from Lab1 API");
            throw;
        }
    }

    public async Task<ProductDto?> GetProductByIdAsync(string id)
    {
        try
        {
            var response = await _httpClient.GetAsync($"/api/v1/products/{id}");
            
            if (response.StatusCode == System.Net.HttpStatusCode.NotFound)
            {
                return null;
            }
            
            response.EnsureSuccessStatusCode();

            var content = await response.Content.ReadAsStringAsync();
            var apiResponse = JsonSerializer.Deserialize<Lab1Response<ProductDto>>(content, _jsonOptions);

            return apiResponse?.Data;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error fetching product {ProductId} from Lab1 API", id);
            throw;
        }
    }
}

/// <summary>
/// Model odpowiedzi z API Lab 1
/// </summary>
internal class Lab1Response<T>
{
    public bool Success { get; set; }
    public T? Data { get; set; }
    public string? Message { get; set; }
}
