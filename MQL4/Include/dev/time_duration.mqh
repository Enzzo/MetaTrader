class TimeDuration{
public:
    TimeDuration(){
        _start = GetMicrosecondCount();
    }
    ~TimeDuration(){
        _end = GetMicrosecondCount();
        Print("Timer: " + IntegerToString(_end - _start));
        Print("Start: " + IntegerToString(_start));
        Print("End: " + IntegerToString(_end));
    }

private:
    ulong _start, _end;
};

#define TIMER TimeDuration timer##__LINE__