package utils

func Abs[T int | uint | int8 | uint8 | int64 | uint64](x T) T {
    if x < 0 {
        return -x
    }
    return x
}

func AbsDiff[T int | uint | int8 | uint8 | int64 | uint64](x, y T) T {
    if x < y {
        return y - x
    }
    return x - y
}
