--Covid-19 Data Exploration 


Select *
From PortfolioProject..['Covid Deaths$']
Where continent is not null 
order by 3,4

-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..['Covid Deaths$']
Where continent is not null 
order by 1,2


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country


Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..['Covid Deaths$']
Where location like '%states%'
and continent is not null 
order by 1,2


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..['Covid Deaths$']
order by 1,2


--Looking at countries with high infection rate compared to population

SELECT location, MAX(total_cases) AS HighstInfectionCount, MAX((total_cases/population))*100 AS CovidCasesPercentage
FROM PortfolioProject..['Covid Deaths$']
--WHERE location = 'Egypt'
Group by location, population
ORDER BY CovidCasesPercentage Desc

--Showing countries with high death count per population

SELECT location, MAX(Cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..['Covid Deaths$']
--WHERE location = 'Egypt'
Where continent is not null
Group by location
ORDER BY TotalDeathCount Desc

--Global Numbers

SELECT date, Sum(new_cases) as TotalCases, Sum(Cast(new_deaths as int))TotalDeaths, (Sum(Cast(new_deaths as int))/Sum(new_cases))*100 as DeathsPercentage
FROM PortfolioProject..['Covid Deaths$']
--WHERE location = 'Egypt'
Where continent is not null
Group by date
Order by 1,2

--Looking at Total Population vs Vaccination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) Over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..['Covid Deaths$'] dea
Join PortfolioProject..CovidVaccinations$ vac
     On  dea.location = vac.location
	 And dea.date = vac.date
Where dea.continent is not null
Order by 1,2,3

--Use CTE
With PopvsVac(Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) Over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..['Covid Deaths$'] dea
Join PortfolioProject..CovidVaccinations$ vac
     On  dea.location = vac.location
	 And dea.date = vac.date
Where dea.continent is not null
)
Select * , (RollingPeopleVaccinated/Population)*100
From PopvsVac


--Creating view to store Data for later Visualization

Create View PercentVacccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) Over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..['Covid Deaths$'] dea
Join PortfolioProject..CovidVaccinations$ vac
     On  dea.location = vac.location
	 And dea.date = vac.date
Where dea.continent is not null
