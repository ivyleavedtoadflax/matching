library(dplyr)
library(Matching)
data("lalonde")

## outcome of interest and treatment indicator

Y <- lalonde$re78
Tr <- lalonde$treat
  
# estimate first propensity model using a glm

glm1 <- glm(
  Tr ~ 
    age +
    educ +
    black + 
    hisp +
    married +
    nodegr + 
    re74 +
    re75,
  family = binomial,
  data = lalonde
)

## Now one to one matching with replacement

rr1 <- Match(
  Y = Y, 
  Tr = Tr, 
  X = glm1$fitted,
  ties = TRUE,
  estimand = "ATT"
)

## See results from Match

summary(rr1)

## Now check the balance of our propensity score model. Note that this model uses many more variables than the model itself.

MatchBalance(
  Tr ~ 
    age + I(age^2) + educ + 
    I(educ^2) + black + hisp +
    married + nodegr + re74 +
    I(re74^2) + re75 + I(re75^2) + 
    u74 + u75 + I(re74 * re75) + 
    I(age * nodegr) + I(educ * re74) + 
    I(educ * re75),
  match.out = rr1, 
  nboots = 1000, 
  data = lalonde
)

## Consider nodegr See summary statistics. First set shows means for treatment 
## and control and mean difference in standard deviation. Second set shows
## statistics based on the raw empirical-QQ plots, and hence are in the same
## scale as the variable being tested. The third set of statistics are the same
## empirical QQ statistics, but this time standardised. Finally there is the
## variance ration - the closer this is to 1, the better the match, and a
## p-value from a t-test of the difference of the means (not paired). For nodegr
## there were significant differences between treatments before and after
## matching.

# Now for re74.

qqplot(
  lalonde$re74[rr1$index.control], 
  lalonde$re74[rr1$index.treated]
  )

abline(
  coef = c(0, 1), 
  col = 2
  )

### Try matching again with Mahalanobis distance

X <- lalonde %>%
  dplyr::select(
    age,
    educ,
    black,
    hisp,
    married,
    nodegr,
    re74,
    re75
    )

str(X)

## Now one to one matching with replacement

rr2 <- Match(
  Y = Y, 
  Tr = Tr, 
  X = X,
  Weight = 2
  )

rr2$index.treated
rr2$index.control

MatchBalance(
  Tr ~ 
    age + I(age^2) + educ + 
    I(educ^2) + black + hisp +
    married + nodegr + re74 +
    I(re74^2) + re75 + I(re75^2) + 
    u74 + u75 + I(re74 * re75) + 
    I(age * nodegr) + I(educ * re74) + 
    I(educ * re75),
  match.out = rr2, 
  nboots = 1000, 
  data = lalonde
)

par(mfrow=c(1,2))
qqplot(
  lalonde$re74[rr1$index.control], 
  lalonde$re74[rr1$index.treated]
)
abline(
  coef = c(0, 1), 
  col = 2
)
qqplot(
  lalonde$re74[rr2$index.control], 
  lalonde$re74[rr2$index.treated]
)
abline(
  coef = c(0, 1), 
  col = 2
)
