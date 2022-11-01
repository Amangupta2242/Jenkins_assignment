#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Jenkins_assignment.csproj", "."]
RUN dotnet restore "./Jenkins_assignment.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "Jenkins_assignment.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Jenkins_assignment.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Jenkins_assignment.dll"]