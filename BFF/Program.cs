using MobileBFF.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();

// HTTP Clients for backend services
builder.Services.AddHttpClient<IProductService, ProductService>(client =>
{
    client.BaseAddress = new Uri(builder.Configuration["Services:ProductApi"] ?? "http://localhost:5220");
});

builder.Services.AddHttpClient<ICartService, CartService>(client =>
{
    client.BaseAddress = new Uri(builder.Configuration["Services:CartApi"] ?? "http://localhost:5086");
});

// Agregujący serwis BFF
builder.Services.AddScoped<IBffService, BffService>();

// CORS - pozwala na dostęp z aplikacji mobilnej
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

var app = builder.Build();

app.UseCors("AllowAll");
app.MapControllers();

app.Run();
