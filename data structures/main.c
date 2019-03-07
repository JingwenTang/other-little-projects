#include <stdio.h>
#include <stdlib.h>
int x=0,n;
int *post;
void postorder(int a[],int b[],int n);


int main()
{
    int i;
    scanf("%d",&n);
    post=(int*)malloc(sizeof(int)*n);
    int* a=(int*)malloc(sizeof(int)*n);
    int* b=(int*)malloc(sizeof(int)*n);
    for(i=0;i<n;i++) scanf("%d",&a[i]);
    for(i=0;i<n;i++) scanf("%d",&b[i]);
    postorder(a,b,n);
    for(i=0;i<n;i++) printf("%d ",post[i]);
    return 0;
}

void postorder(int a[],int b[],int m)
{
    int i;
    x++;
    post[n-x]=a[0];
    int node=a[0];
    int count=0;
    while(b[count]!=node) count++;
    if(m-count-1>0)
    {
        int* a2=(int*)malloc(sizeof(int)*(m-count-1));
        int* b2=(int*)malloc(sizeof(int)*(m-count-1));
        for(i=count+1;i<=m-1;i++)
        {
            a2[i-count-1]=a[i];
            b2[i-count-1]=b[i];
        }
        postorder(a2,b2,m-count-1);
    }
    if(count>0)
    {
        int* a1=(int*)malloc(sizeof(int)*(count));
        int* b1=(int*)malloc(sizeof(int)*(count));
        for(i=1;i<=count;i++)
        {
            a1[i-1]=a[i];
            b1[i-1]=b[i-1];
        }
        postorder(a1,b1,count);
    }

}
