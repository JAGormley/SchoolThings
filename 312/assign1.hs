--Susannah Kirby ########
--Andrew Gormley 22724124


-- 1
-- use some Float params as well, ie partial hours?
-- div by zero check (what should it do in this case)?
-- do we need to restrict the input ranges somehow?

preparednessQuotient :: Int -> Int -> Int -> Int -> Int -> Int -> Int -> Float
preparednessQuotient i s c pn pa d n = (fi (pqNumer pa s c)) / (fi (pqDenom pn d n i))

pqNumer :: Int -> Int -> Int -> Int
pqNumer pa s c = 8 * pa * (s+c)

pqDenom :: Int -> Int -> Int -> Int -> Int
pqDenom pn d n i = 3*pn*(d+n+i)


-- 2

kungPaoFactor :: Int -> Int -> Int -> Int -> Int -> Int -> Int -> Int -> Float
kungPaoFactor r dm ds n c ft ff s = (left n ds dm) + (right s r c ft ff)

left :: Int -> Int -> Int -> Float
left n ds dm = ((fi n) / 30) - ((fi ds) / (fi dm))

right :: Int -> Int -> Int -> Int -> Int -> Float
right s r c ft ff = (kpNumer s r) / (kpDenom c ft ff)

kpNumer :: Int -> Int -> Float
kpNumer s r = 10 * ((fi s)^2) * (sqrt (fi r))

kpDenom :: Int -> Int -> Int -> Float
kpDenom c ft ff = fi(c * (ft - ff + 1))


-- 3

multiply :: Int -> Int -> Int
multiply x y
    | (x == 0 || y == 0)     = 0
    | y == 1                 = x
    | otherwise              = x + multiply x (y-1)


-- 4

multiply_tr :: Int -> Int -> Int
multiply_tr x y = mult_helper x y x

mult_helper :: Int -> Int -> Int -> Int
mult_helper x y acc
    | (x == 0 || y == 0)     = 0
    | y == 1                 = acc
    | otherwise              = mult_helper x (y-1) acc+x

-- 5

power :: Int -> Int -> Int
power x y
    | x == 0                  = 0
    | y == 0                  = 1
    | y == 1                  = x
    | otherwise               = multiply x (power x (y-1))


-- 6

power_tr :: Int -> Int -> Int
power_tr x y = power_helper x y x

power_helper :: Int -> Int -> Int -> Int
power_helper x y acc
    | x == 0                  = 0
    | y == 0                  = 1
    | y == 1                  = acc
    | otherwise               = power_helper x (y-1) (multiply_tr acc x)


-- 7
-- check for 0?
-- by Real does he mean Float?

harmonic :: Int -> Float
harmonic n
    | n == 1                  = 1.0
    | otherwise               = 1/(fi n) + harmonic (n - 1)


-- 8

harmonic_tr :: Int -> Float
harmonic_tr n = harmonic_helper n 1.0

harmonic_helper :: Int -> Float -> Float
harmonic_helper n acc
    | n == 1                  = acc
    | otherwise               = harmonic_helper (n - 1) (1/(fi n) + acc)


-- GENERAL HELPER

fi :: Int -> Float
fi i = fromIntegral i
