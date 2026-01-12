namespace MobileBFF.Models;

/// <summary>
/// Model koszyka dla aplikacji mobilnej
/// </summary>
public class CartDto
{
    public string Id { get; set; } = string.Empty;
    public string UserId { get; set; } = string.Empty;
    public List<CartItemDto> Items { get; set; } = new();
    public double TotalAmount { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
}

/// <summary>
/// Model pozycji koszyka
/// </summary>
public class CartItemDto
{
    public string ProductId { get; set; } = string.Empty;
    public string ProductName { get; set; } = string.Empty;
    public int Quantity { get; set; }
    public double UnitPrice { get; set; }
    public double TotalPrice { get; set; }
}

/// <summary>
/// Request do utworzenia koszyka
/// </summary>
public class CreateCartRequest
{
    public string UserId { get; set; } = string.Empty;
}

/// <summary>
/// Request do dodania produktu do koszyka
/// </summary>
public class AddToCartRequest
{
    public string ProductId { get; set; } = string.Empty;
    public int Quantity { get; set; } = 1;
}
