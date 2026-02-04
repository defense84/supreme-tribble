# Build stage
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Copy solution file
COPY ["supreme-tribble.slnx", "./"]

# Copy project files
COPY ["CodExponential/CodExponential.csproj", "CodExponential/"]
COPY ["Images/Images.csproj", "Images/"]
COPY ["CodExponential.ui/CodExponential.ui.csproj", "CodExponential.ui/"]
COPY ["BenchmarkSuite1/BenchmarkSuite1.csproj", "BenchmarkSuite1/"]

# Restore dependencies
RUN dotnet restore "supreme-tribble.slnx"

# Copy all source code
COPY . .

# Build the main project
WORKDIR "/src/CodExponential"
RUN dotnet build "CodExponential.csproj" -c Release -o /app/build

# Publish stage
FROM build AS publish
RUN dotnet publish "CodExponential.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
EXPOSE 8080
EXPOSE 8081
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CodExponential.dll"]
