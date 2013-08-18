#include <pthread.h>
#include "thread_work.h"

int comp[ARRAY_SIZE];
volatile int compHead = 0;
volatile int compTail = 0;

pthread_mutex_t mlock;

void spinlock_create(spinlock_t* lock)
{
    *lock = 0;
}

void spinlock_lock(spinlock_t* lock)
{
    int already_held;
    do {
        while(*lock);
        __asm volatile("movl  $1, %%eax\n\t"
                       "xchgl %0, %%eax\n\t"
                       : "=m" (*lock), "=ra" (already_held));
    } while(already_held);
}

void spinlock_unlock(spinlock_t* lock)
{
    *lock = 0;
}

void initialise()
{
    pthread_mutex_init (&mlock, NULL);
}

void* thread_work(void *args)
{
    thread_args *ta = (thread_args *) args;
    int thread_id = ta->id;
    int total_threads = ta->tot_threads;
    
    //    total_threads * compTail + thread_id
    
    
    
    while (compTail < compHead) {
        
        if (compTail % total_threads == thread_id){
            pthread_mutex_lock (&mlock);
            
            int val = comp[compTail];
            compTail = (compTail + 1) % ARRAY_SIZE;
            
            /* do not change the format of this printf or print anything else from
             * the files you hand in */
            printf("%d of %d : %d\n", thread_id,
                   total_threads, val);
            fflush(stdout);
            
            pthread_mutex_unlock (&mlock);
        }
    }
    
    
    
    return NULL;
}

void finalise()
{
    pthread_mutex_destroy(&mlock);
}
