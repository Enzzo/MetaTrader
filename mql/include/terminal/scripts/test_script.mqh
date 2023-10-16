class TestScript{
public:
    TestScript(){};
    
    void run(){
        #ifdef MT5
            Print("MT5");
        #endif
        #ifdef MT4
            Print("MT4");
        #endif
    }
};