/*
 * Put here the JavaScript code from
 * 	http://www.nearly42.org/games/icosoku-solver/
 * (I have not asked permission to use this code). Function icosolve must be
 * parametrized to accept in input the description of the capacities using his
 * naming convention.
 * ~ Nicola Rizzo
 */


// Measure the solving time
var start = new Date();
icosolve([x,x,x,x,x,x,x,x,x,x,x,x,]);
var end = new Date();
console.log((end - start)/1000 + "");
