// License: CC BY-NC-SA 4.0
/*
 * task1.c
 *
 * Find and display in a given one-dimensional array:
 * 1. All numbers are greater than a given N
 * 2. Number of first elements, the sum of which is less than N
 * 3. The maximum element among the first N elements
 * 4. All elements whose index is a multiple of N
 *
 * Written by AlexeyFilich
 * 10 oct 2020
 */

#define STORAGE_OPTIMAL

#include <stdbool.h>
#include <stdio.h>
#include "Interactions.h"
#include "Random.h"
#include "storage/Storage.h"

void greaterThanN(Array * array, int n) {
    printf("Greater than N: ");
    for (int i = 0; i < array->size; i++)
        if (aArrayGetAs(array, i, int) > n) printf("%d ", aArrayGetAs(array, i, int));
    printf("\n");
}

void sumLessThanN(Array * array, int n) {
    int sum = 0;
    for (int i = 0; i < array->size; i++) {
        sum += aArrayGetAs(array, i, int);
        if (sum > n) {
            printf("Amount of sum of first before N: %d\n", i);
            return;
        }
    }
    printf("Amount of sum of first before N: %d\n", array->size);
}

void maxUpToN(Array * array, int n) {
    int max = 0;
    for (int i = 0; i < n; i++)
        if (aArrayGetAs(array, i, int) > max) max = aArrayGetAs(array, i, int);
    printf("Max up to N: %d\n", max);
}

void indexIsN(Array * array, int n) {
    printf("Index is divideable by N: ");
    for (int i = 0; i < array->size; i++)
        if (i % n == 0) printf("%d ", aArrayGetAs(array, i, int));
    printf("\n");
}

int main(int argc, char* args[]) {
    int N, option;
    Array array;
    void (*functions[4])(Array *, int) = { &greaterThanN, &sumLessThanN, &maxUpToN, &indexIsN }; // function pointer array
    while (true) {
        aArrayInit(&array, 10, int); // Initialize an array and fill it with random integers
        for (int i = 0; i < array.size; i++) {
            aArraySetI(&array, i, aRandInt(-10, 10));
            printf("[%2d] %3d\n", i, aArrayGetAs(&array, i, int));
        }
        aScanCheck("N: ", "%d", &N); // Read N
        printf("Select option:\n1: Find number greater than N\n2: Find amount of first numbers sum of which is less than N\n3: Find max number in array before n-th index\n4: Find all numbers, indexes of which are divideable by N\n");
        do {
            aScanCheck("Option: ", "%d", &option);
        } while (option < 1 && option > 4);
        (*functions[option - 1])(&array, N);
        if (aQToExit()) break; // Exit prompt
    }
    aArrayDestroy(&array);

    printf("Done!\n");
    return 0;
}
