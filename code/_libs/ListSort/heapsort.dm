proc
	ls_heapsort(list/L)
		var/heap_size = L.len
		for(var/i=L.len*0.5, i>=1, --i)
			ls_heapify(L, i, heap_size)
		for(var/i=L.len, i>=2, --i)
			L.Swap(i, 1)
			ls_heapify(L, 1, --heap_size)

	ls_heapsort_cmp(list/L, cmp)
		var/heap_size = L.len
		for(var/i=L.len*0.5, i>=1, --i)
			ls_heapify_cmp(L, i, heap_size, cmp)
		for(var/i=L.len, i>=2, --i)
			L.Swap(i, 1)
			ls_heapify_cmp(L, 1, --heap_size, cmp)

proc	// helper procs
	ls_heapify(list/A, i, heap_size)
		var
			l
			r
			upper
		for()
			l = i+i
			r = l+1

			if(l<=heap_size && A[l]>A[i])
				upper = l
			else
				upper = i

			if(r<=heap_size && A[r]>A[upper])
				upper = r

			if(upper != i)
				A.Swap(upper, i)
				i = upper
			else break

	ls_heapify_cmp(list/A, i, heap_size, cmp)
		var
			l
			r
			upper
		for()
			l = i+i
			r = l+1

			if(l<=heap_size && call(cmp)(A[l],A[i])>0)
				upper = l
			else
				upper = i

			if(r<=heap_size && call(cmp)(A[r],A[upper])>0)
				upper = r

			if(upper != i)
				A.Swap(upper, i)
				i = upper
			else break