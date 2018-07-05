# Set up date ranges
dgn_date_range <- seq.Date(as.Date('2013-01-01'), as.Date('2013-12-31'), by = 1)
birth_date_range <- seq.Date(as.Date('1928-01-01'), as.Date('1947-12-31'), by = 1)

# --------------- #
# Simulate data
# --------------- #
# Set number of observations
n = 10000
# Set random seed
set.seed(101)
# ID
id = 1:n
# Birth date
birth_date <- sample(birth_date_range, n, replace = T)
# Diagnosis date
dgn_date <- sample(dgn_date_range, n, replace = T)
# Compute Age 
age <- as.integer(dgn_date - birth_date)/365
# Sex
sex <- sample(c('female', 'male'), n, replace = T, prob = c(.51, .49))
# Race
race <- sample(c('white', 'black'), n, replace = T, prob = c(.88, .12))

# Mortality
rate <- .005 * 
   (1 + .3 * as.integer(race == 'black')) *
   (1 + 3 * (age - 65))
days_til_death <- floor(rexp(n, rate))
mort_30 <- as.integer(days_til_death <= 30)
mort_90 <- as.integer(days_til_death <= 90)
mort_365 <- as.integer(days_til_death <= 365)

# Bind into data frame
data <- dplyr::tibble(
   id, birth_date, dgn_date, mort_30, mort_90, mort_365, sex, race
)

# Save data
haven::write_dta(data, 'data/ami_hospitalizations.dta')