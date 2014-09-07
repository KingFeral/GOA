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