namespace MobileBFF.Models;

/// <summary>
/// Ujednolicona odpowiedź API dla aplikacji mobilnej
/// </summary>
public class BffResponse<T>
{
    public bool Success { get; set; }
    public T? Data { get; set; }
    public string? Message { get; set; }
    public string? ErrorCode { get; set; }

    public static BffResponse<T> Ok(T data, string? message = null)
    {
        return new BffResponse<T>
        {
            Success = true,
            Data = data,
            Message = message
        };
    }

    public static BffResponse<T> Fail(string message, string? errorCode = null)
    {
        return new BffResponse<T>
        {
            Success = false,
            Message = message,
            ErrorCode = errorCode
        };
    }
}
