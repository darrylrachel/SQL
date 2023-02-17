-- Data going to be using
SELECT "location", date, total_cases, new_cases, total_deaths, population
  FROM "CovidDeaths"
  WHERE contient IS NOT NULL
  ORDER BY 1, 2;

-- Total cases vs total deaths
-- Likelihood of dying if you contract Covid in your counrty
SELECT "location", "date", total_cases, total_deaths, (total_deaths / total_cases) * 100 AS DeathPercentage
  FROM "CovidDeaths"
  WHERE "location" LIKE '%States%'
  ORDER BY 1, 2;

-- Total cases vs Population
SELECT "location", "date", population, total_cases, (total_cases / population) * 100 AS PercentPopulationInfected
  FROM "CovidDeaths"
  WHERE "location" LIKE 'United States'
  ORDER BY 1, 2;

-- Countries with highest infection rate compared to popolation
SELECT "location", population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases / population)) * 100 AS PercentPopulationInfected
  FROM "CovidDeaths"
--where "location" like 'United States'
  GROUP BY "location", population
  ORDER BY PercentPopulationInfected DESC;

-- Showing countries with highest death count per population
SELECT "location", MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
  FROM "CovidDeaths"
  WHERE continent IS NOT NULL
  GROUP BY "location"
  ORDER BY TotalDeathCount DESC;

-- Break down by continent
/* SELECT "location", MAX(cast(total_deaths as int)) as TotalDeathCount
  from "CovidDeaths"
  where continent is null
  GROUP by "location"
  order by TotalDeathCount desc;
*/

-- Showing the continent with the highest death count
SELECT continent, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
  FROM "CovidDeaths"
  WHERE continent IS NOT NULL
  GROUP BY continent
  ORDER BY TotalDeathCount DESC;

-- Global Numbers
SELECT "date", SUM(CAST(new_cases AS INT)) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, SUM(CAST(new_deaths AS INT)) / SUM(CAST(new_cases AS INT)) AS DeathPercentage
  FROM "CovidDeaths"
  WHERE continent IS NOT NULL
  GROUP BY "date"
  ORDER BY 1, 2;
  
  -- Global Numbers overall
SELECT SUM(CAST(new_cases AS INT)) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, SUM(CAST(new_deaths AS INT)) / SUM(CAST(new_cases AS INT)) AS DeathPercentage
  FROM "CovidDeaths"
  WHERE continent IS NOT NULL
  --group by "date"
  ORDER BY 1, 2;


-- Total population vaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
  FROM "CovidDeaths" dea
  JOIN "CovidVaccinations" vac
    ON dea.location = vac.location
    AND dea.date = vac.date
  WHERE dea.continent IS NOT NULL  
  ORDER BY 2, 3;




