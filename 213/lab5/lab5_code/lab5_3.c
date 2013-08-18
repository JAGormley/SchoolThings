int res;
int k = 10;
			  	

/* stub code makes this call */
get();

void get() {
 res = fun(k/2)
}

int fun(int p){
    if (p >= 2){
        fun(p--);
        
        
    }
    return p;
}