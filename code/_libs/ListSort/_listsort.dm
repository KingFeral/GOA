/*
		ListSort by Kuraudo

	ListSort is a library containing several functions for sorting lists. Currently, it supports
	the following algorithms:

		Quicksort
			- A popular method for sorting lists, with generally good performance.
				It is generally one of the faster algorithms, though can have O(n^2) performance
				in a worst-case, so it may not always be desirable for larger lists.

			Available procs:

				ls_quicksort(list/L)
					Sorts L using the Quicksort algorithm.

				ls_quicksort_cmp(list/L, cmp)
					Sorts L using the Quicksort algorithm and comparison function "cmp," which
					may be used to sort data of types not supported by BYOND's comparison operators,
					or to sort in descending order.

		Heapsort
			- Another popular sorting algorithm, with generally slower performance than Quicksort,
				but a worst-case complexity of O(n log n) performance, which makes it more desirable
				than Quicksort in some situations.

			Available procs:

				ls_heapsort(list/L):
					Sorts L using the Heapsort algorithm.

				ls_heapsort_cmp(list/L, cmp):
					Sorts L using the Heapsort algorithm and comparison function "cmp," which
					may be used to sort data of types not supported by BYOND's comparison operators,
					or to sort in descending order.

	Other algorithms may be supported in the future. When writing comparison functions keep the following
	in mind:

	1. Comparison functions take two arguments, x and y.
	2. Comparison functions should return the following:

		x == y	returns	0
		x < y	returns less than 0
		x > y	returns greater than 0

	3. To sort into descending order, return a negative number if x>y and a positive number if x<y.

*/