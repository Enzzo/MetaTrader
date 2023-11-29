#include <trade/mm.mqh>

class TestScript{
public:
    TestScript(){};
    
    void run(){
        Print("Test script");
    }

private:
    mm _mm;
};