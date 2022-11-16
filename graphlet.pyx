# cython: language_level=3
import numpy  as np
cimport numpy as np
from libcpp cimport bool

cdef extern from "orca.cpp":
    cdef cppclass _GraphletCounter:
        _GraphletCounter(int,int,np.int64_t*,np.int64_t*) except +
        void count(int,bool,np.int64_t*) except +

cdef class GraphletCounter:
    cdef _GraphletCounter * gc
    cdef int n, e
    def __init__(self, int n, np.ndarray[np.int64_t, ndim=1] u, np.ndarray[np.int64_t, ndim=1] v):
        assert u.shape[0] == v.shape[0], "invalid edge shape"
        u, v = u.copy(), v.copy()
        self.n = n
        self.e = u.shape[0]
        self.gc = new _GraphletCounter(self.n, self.e, <np.int64_t*>&u[0], <np.int64_t*>&v[0])

    def __del__(self):
        del self.gc

    def __repr__(self):
        return f'GraphletCounter(num_nodes={self.n}, num_edges={self.e})'

    def count(self, int graphlet_size, bool node_graphlet=True):
        assert graphlet_size in [4, 5], "graphlet size must be in set [4, 5]"
        cdef np.ndarray[np.int64_t, ndim=2] ret
        if node_graphlet:
            if graphlet_size == 4:
                ret = np.empty((self.n, 15), dtype=np.int64)
            elif graphlet_size == 5:
                ret = np.empty((self.n, 73), dtype=np.int64)
        else:
            if graphlet_size == 4:
                ret = np.empty((self.e, 12), dtype=np.int64)
            elif graphlet_size == 5:
                ret = np.empty((self.e, 68), dtype=np.int64)
        self.gc.count(graphlet_size, node_graphlet, <np.int64_t*>&ret[0,0])
        return ret
