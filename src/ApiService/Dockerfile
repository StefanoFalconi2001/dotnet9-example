# Build Phase
FROM mcr.microsoft.com/dotnet/sdk:9:0 AS Build
WORKDIR /app
COPY . . 
RUN dotnet publish -c Release -o /out

# Runtime Phase
FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app
COPY --from=build /out .
ENTRYPOINT [ "dotnet", "ApiService.dll" ]

