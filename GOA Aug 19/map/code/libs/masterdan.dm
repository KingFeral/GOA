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

proc
	ls_quicksort(list/L, start=1, end=L.len)
		if(start < end)
			var/q = ls_partition(L, start, end)
			ls_quicksort(L, start, q-1)
			ls_quicksort(L, q+1, end)

	ls_quicksort_cmp(list/L, cmp, start=1, end=L.len)
		if(start < end)
			var/q = ls_partition_cmp(L, cmp, start, end)
			ls_quicksort_cmp(L, cmp, start, q-1)
			ls_quicksort_cmp(L, cmp, q+1, end)

proc	// helper procs
	ls_partition(list/L, p, r)
		var
			pivot
			m = (p + r) * 0.5
		if(L[p] > L[m])
			L.Swap(p, m)
		if(L[p] > L[r])
			L.Swap(p, r)
		if(L[m] > L[r])
			L.Swap(m, r)
		pivot = r-1
		if(r-p > 2)
			r--
			L.Swap(m, pivot)
			for()
				while(L[++p] < L[pivot]);
				while(L[--r] > L[pivot]);
				if(p < r)
					L.Swap(p, r)
				else
					break
			L.Swap(p, pivot)
			return p
		else return m

	ls_partition_cmp(list/L, cmp, p, r)
		var
			pivot
			m = (p + r) * 0.5
		if(call(cmp)(L[p],L[m]) > 0)
			L.Swap(p, m)
		if(call(cmp)(L[p],L[r]) > 0)
			L.Swap(p, r)
		if(call(cmp)(L[m],L[r]) > 0)
			L.Swap(m, r)
		pivot = r-1
		if(r-p > 2)
			r--
			L.Swap(m, pivot)
			for()
				while(call(cmp)(L[++p],L[pivot]) < 0);
				while(call(cmp)(L[--r],L[pivot]) > 0);
				if(p < r)
					L.Swap(p, r)
				else
					break
			L.Swap(p, pivot)
			return p
		else return m

proc
	layer_sort(x, y)
		return x:layer - y:layer