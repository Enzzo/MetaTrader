#include <Object.mqh>

template<typename T>
class queue : public CObject{
private:
    T m_array[];

public:
    queue(){};
    queue operator=(const queue&);

    T front() const;
    T back() const;

    bool empty() const;
    int size() const;

    void push(const T&);
    T emplace(const T&);
    T pop();
    void swap(queue<T>& other);
};

template<typename T>
int queue::size<T>() const{
    return ArraySize(m_array);
}