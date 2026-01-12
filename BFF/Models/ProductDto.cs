namespace MobileBFF.Models;

/// <summary>
/// Model produktu - uproszczona wersja dla aplikacji mobilnej
/// </summary>
public class ProductDto
{
    public string Id { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;
    public string Category { get; set; } = string.Empty;
    public double Price { get; set; }
    public int Quantity { get; set; }
    public DateTime CreatedAt { get; set; }
}

/// <summary>
/// Lista produktów z metadanymi
/// </summary>
public class ProductListDto
{
    public List<ProductDto> Products { get; set; } = new();
    public int TotalCount { get; set; }
}
