#property copyright "Sergey"
#property link "http://mql5.com/enzzo"
#property version "1.00"

struct test{
    int a;
}t;
t.a = 20;

int OnInit(){
   t.a = 10;
    return INIT_SUCCEEDED;
}

void OnTick(){

}

