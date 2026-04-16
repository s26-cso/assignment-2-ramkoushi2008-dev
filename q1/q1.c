#include <stdio.h>

struct Node{
    int val;
    struct Node* left;
    struct Node* right;
};

struct Node* make_node(int);
struct Node* insert(struct Node*, int);
struct Node* get(struct Node*, int);
int getAtMost(int, struct Node*);

int main(){
    struct Node* root=0;
    root=insert(root, 2);
    root=insert(root, 1);
    root=insert(root, 3);
    struct Node* res=get(root, 1);
    if(res) printf("Found: %d\n", res->val);
    else printf("Not found\n");
    printf("getAtMost(5): %d\n", getAtMost(5, root));
    return 0;
}