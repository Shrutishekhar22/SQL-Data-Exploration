use portfolio_project

SELECT *
FROM CovidDeaths
WHERE continent is not NULL
ORDER BY 3,4

SELECT *
FROM CovidVaccinations
ORDER BY 3,4

SELECT location,date,total_cases,new_cases,total_deaths,population
FROM CovidDeaths
ORDER BY 1,2

--Total cases versus total deaths
SELECT location,date,total_cases,new_cases,total_deaths,population, (total_deaths/total_cases)*100 AS Death_percentage
FROM CovidDeaths
WHERE location like '%India%'
ORDER BY 1,2

-- Total cases vs population
-- Shows what percentage of population got covid

SELECT location,date,total_cases,population, (total_cases/population)*100 AS Covid_percentage
FROM CovidDeaths
WHERE location like '%India%'
ORDER BY 1,2

-- Looking at the countries with highest infection rate compared to its population

SELECT location,Max(total_cases) AS HighestInfectionCount,population, Max((total_cases/population))*100 AS Covid_percentage
FROM CovidDeaths
GROUP BY location,population
ORDER BY Covid_percentage DESC

-- Showing Highest Death Count Per Population

SELECT location,MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM CovidDeaths
WHERE continent is not NULL
GROUP BY location
ORDER BY 2 DESC;

-- Lets break things down by continents

SELECT continent,MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM CovidDeaths
WHERE continent is not NULL
GROUP BY continent
ORDER BY 2 DESC;

--Showing continents with the highest death count per population
SELECT continent,MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM CovidDeaths
WHERE continent is not NULL
GROUP BY continent
ORDER BY 2 DESC;

--Global Number
SELECT SUM(new_cases) AS Total_cases,SUM (cast(new_deaths as int)) AS Total_Deaths, SUM (cast(new_deaths as int))/SUM (new_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE continent is not NULL
ORDER BY 1,2

--Joining the tables
SELECT *
FROM CovidDeaths as dea
JOIN CovidVaccinations as vac
    ON dea.location=vac.location
	AND dea.date=vac.date

	-- Looking at Total Population vs Vaccinations

SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date ) AS RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
    ON dea.location=vac.location
	AND dea.date=vac.date
WHERE dea.continent is not NULL
ORDER BY 2,3


--TEMP TABLE
DROP TABLE if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
( 
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)


--Creating view to store data for later visualization

CREATE VIEW PercentPopulationVaccinated as
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date ) AS RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
FROM CovidDeaths dea
JOIN CovidVaccination vac
    ON dea.location=vac.location
	AND dea.date=vac.date
WHERE dea.continent is not NULL
--ORDER BY 2,3

SELECT *
FROM PercentPopulationVaccinated