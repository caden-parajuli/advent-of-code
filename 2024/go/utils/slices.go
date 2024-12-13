package utils

func RemoveIndexCopy(s []int, index int) []int {
    ret := make([]int, 0)
    ret = append(ret, s[:index]...)
    return append(ret, s[index+1:]...)
}

func RemoveIndex(s []int, index int) []int {
    return append(s[:index], s[index+1:]...)
}
