select *
from portfolioproject1..coviddeaths
order by 3,4

select *
from  portfolioproject1..coviddvaccinations



Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject1..CovidDeaths
order by 1,2


Select Location, date, total_cases, total_deaths , (total_deaths/total_cases)*100 as deathpercentage
From PortfolioProject1..CovidDeaths
order by 1,2


Select Location, date,population, total_cases,  (total_cases/population)*100 as casespercentage
From PortfolioProject1..CovidDeaths
order by 1,2



Select Location,population, max(total_cases),  max((total_cases/population))*100 as maxcasespercentage
From PortfolioProject1..CovidDeaths
group by location , population
order by maxcasespercentage desc




Select Location, max(cast(total_deaths as int)) as totaldeathcount
From PortfolioProject1..CovidDeaths
where continent is not null
group by location 
order by totaldeathcount desc


Select continent, max(cast(total_deaths as int)) as totaldeathcount
From PortfolioProject1..CovidDeaths
where continent is not null
group by continent
order by totaldeathcount desc




Select Location, max(cast(total_deaths as int)) as totaldeathcount
From PortfolioProject1..CovidDeaths
where continent is  null
group by location 
order by totaldeathcount desc




select date , sum(new_cases) as totalcases,sum(cast(new_deaths as int)) as totaldeaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercantage
From PortfolioProject1..CovidDeaths
where continent is not  null
group by date
order by 1,2 





select sum(new_cases) as totalcases,sum(cast(new_deaths as int)) as totaldeaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercantage
From PortfolioProject1..CovidDeaths
where continent is not  null
order by 1,2 




select *
from portfolioproject1..coviddeaths dea
join  portfolioproject1..coviddvaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date





select dea.continent , dea.location,dea.date , dea.population , vac.new_vaccinations
from portfolioproject1..coviddeaths dea
join  portfolioproject1..coviddvaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not  null
order by 2,3



select dea.continent , dea.location,dea.date , dea.population , vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location)
from portfolioproject1..coviddeaths dea
join  portfolioproject1..coviddvaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not  null
order by 2,3



select dea.continent , dea.location,dea.date , dea.population , vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location , dea.date) as rollingpeoplevaccinated
from portfolioproject1..coviddeaths dea
join  portfolioproject1..coviddvaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not  null
order by 2,3


with popvsvac(continent,location,date,population,new_vaccinations,rollingpeoplevaccinated)
as
(
select dea.continent , dea.location,dea.date , dea.population , vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location , dea.date) as rollingpeoplevaccinated
from portfolioproject1..coviddeaths dea
join  portfolioproject1..coviddvaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not  null
)
select * , (rollingpeoplevaccinated/population)*100
from popvsvac




DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)



Insert into #PercentPopulationVaccinated
select dea.continent , dea.location,dea.date , dea.population , vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location , dea.date) as rollingpeoplevaccinated
from portfolioproject1..coviddeaths dea
join  portfolioproject1..coviddvaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not  null

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

