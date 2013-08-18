/* Try changing a and n to see what happens. */
int *a = { 8, 6, 0, 7, 4, 5, 2, 9, 1 };
int n = 9;

/* stub code makes this call */
sort(a, 0, n-1);

int part(int arr[], int l, int r) {
 int p;
 int t;
 int i;
 t = arr[r];
 arr[r] = arr[l];
 arr[l] = t;
 i = l;
 p = arr[r];
 while(i < r) {
  if(arr[i] <= p) {
   t = arr[i];
   arr[i] = arr[l];
   arr[l] = t;
   l++;
  }
  i++;
 }
 t = arr[l];
 arr[l] = arr[r];
 arr[r] = t;
 return l;
}

void sort(int arr[], int a, int b) {
 int m;
 if(a < b) {
  m = part(arr, a, b);
  sort(arr, a, m-1);
  sort(arr, m+1, b);
 }
}
