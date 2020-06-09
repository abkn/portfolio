package main

import "fmt"

func main() {
	totalScore := 0
	
	ask(1, "Golanguage", &totalScore)
	ask(2, "Python", &totalScore)
	ask(3, "Rust", &totalScore)

	fmt.Println("スコア", totalScore)
}

// 渡されるtotalScoreのポインタを受け取るように変更してください
func ask(number int, question string, scorePtr *int) {
	var input string
	fmt.Printf("[質問%d] 次の単語を入力してください: %s\n", number, question)
	fmt.Scan(&input)

	if question == input {
		fmt.Println("正解!")
		// ポインタを使って加算してください
		*scorePtr += 10
		
	} else {
		fmt.Println("不正解!")
	}
}