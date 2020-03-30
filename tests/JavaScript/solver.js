/*
 * Put here the JavaScript code from
 * 	http://www.nearly42.org/games/icosoku-solver/
 * (I have not asked permission to use this code). Function icosolve must be
 * parametrized to accept in input the description of the capacities using his
 * naming convention, and its output must be suppressed.
 * ~ Nicola Rizzo
 */


// Measure the solving time
var start = new Date();
icosolve([8,11,7,9,10,5,2,4,1,6,3,12,]);
var end = new Date();
console.log((end - start)/1000 + "");
