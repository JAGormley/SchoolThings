// Andrew Gormley
// Student ID 22724124
// CS ID b7q8
// Lab L0A (WF 1:30-3:30pm)
//
// Susannah Kirby
// Student ID 24087124
// CS ID e5r8
// Lab L0A (WF 1:30-3:30pm)

PROGRAMMING ASSIGNMENT 2

/* PLEASE READ THIS FIRST */

We found this homework to be riddled with internal contradictions, typos, etc. and utterly confusing, and when we asked the TAs for guidance, they didn't seem to know what was going on either. The approach to answering the questions and implementing the code that you see here and in our .cpp file was given the okay/go-ahead by Weicong Liao during lab/office hours on Wednesday June 19. Please take this into consideration as you mark.


/* Part 2 */

poorHash()

The poorHash(key) function hashes a string by returning a sum of the ASCII character values of the string modulo the size of the hash table. 

This isn't a great hash function for the following reasons:
- two keys with strings containing same characters in different orders (e.g. PAX, XPA) will end up with same hash values
- "neighbouring" keys (e.g. PAW, PAX) won't hash to very different spots
- since function is based on ASCII values, hashes will be case sensitive (e.g. hash for 'Pax' =/= hash for 'pax'); this may not be desirable
- if strings are words, not all letters are used with equal frequency; will result in non-even distribution of hash values

goodHash()

The goodHash(key) function hashes a string by summing all the ASCII char values, multiplying that result by 37 (a prime) and a psuedorandom number, and then returning that result modulated by the size of the hash table.

This is a better hash function for the following reasons:
- it should more evenly disperse the values in the hash table by taking advantage of the distributing factor of prime and random numbers
- "neighbouring" keys won't end up as neighbours in the table
- should help fix the problem of unequal frequencies of Roman alphabet letters


/* Part 4 */

HASH FN		LOAD FACTOR	TABLE SIZE	ROWS INSERTED	AVG # PROBES 	EXPECTED # PROBES
goodHash	.25 / .2499	40009		10000		1.15		1.15
goodHash	.5 / .4997	20011		10000		1.42		1.39
goodHash	.75 / .7498 	13337		10000		1.95		1.85
poorHash	.25 / .2499 	40009		10000		91.95		1.15	poorHash	.5 / .4997	20011		10000		97.42		1.39
poorHash	.75 / .7498	13337		10000		109.44		1.85

1a. How did you choose your hash functions? Why did you believe one hash function would be better than the other? 
See above ("Part 2") for a description of these functions and their relative merits.

1b. Is your actual load factor much smaller than requested? Why or why not?
Not much smaller - but there is some difference based on the fact that we wanted to find a "slightly higher prime number" of hash table entries, as suggested by the hw assignment directions. 

2. What is the relationship (if any) between load factor and the quality of the hash function?
In both cases, higher load factors result in less efficient hashing.3. How did your results compare to the Knuth estimates for quadratic probing? Discuss briefly (one or two lines is fine).
The estimates were extremely close. In the first case (.25 load) the result was exactly the same as the estimate, and the other two were slightly higher than the estimate.




