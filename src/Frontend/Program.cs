using Frontend.Components;

var builder = WebApplication.CreateBuilder(args);

// Configurar HttpClient para el backend
var backendUrl = Environment.GetEnvironmentVariable("BACKEND_URL") ?? "http://localhost:8080";
builder.Services.AddHttpClient("BackendClient", client =>
{
    client.BaseAddress = new Uri(backendUrl);
});

// Add services to the container.
builder.Services.AddRazorComponents()
    .AddInteractiveServerComponents();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error", createScopeForErrors: true);
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseAntiforgery();

app.MapStaticAssets();
app.MapRazorComponents<App>()
    .AddInteractiveServerRenderMode();

app.Run();
