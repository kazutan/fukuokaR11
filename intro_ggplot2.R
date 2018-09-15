
## ------------------------------------------------------------------------
library(tidyverse)

## ------------------------------------------------------------------------
str(iris)

## ------------------------------------------------------------------------
# ggplotのキャンバスを作成
# あわせてdataとaesも指定
p_0 <- ggplot(data = iris, mapping = aes(x = Sepal.Length, y = Petal.Length))

# 書き出してみる
p_0

## ------------------------------------------------------------------------
# ggplot2ではレイヤーなどを重ねるのに `+` を使います
p_1 <- p_0 + 
  layer(geom = "point", stat = "identity", position = "identity")
# 描いてみる
p_1

## ------------------------------------------------------------------------
# pointのlayerが入ってるp_1に加えます
p_1_2 <- p_1 +
  layer(geom = "line", stat = "identity", position = "identity")
# 描いてみる
p_1_2

## ------------------------------------------------------------------------
# 引数名も省略するパターンが多い
p_2 <- ggplot(iris, aes(x = Sepal.Length, y = Petal.Length)) +
  geom_point() +
  geom_line()
p_2

## ------------------------------------------------------------------------
# aesにcolor = Speciesを追加
p_3 <- ggplot(iris, aes(x = Sepal.Length, y = Petal.Length, color = Species)) +
  geom_point()
# 出力
p_3


## ------------------------------------------------------------------------
# aes内を変更
p_3_2 <- ggplot(iris, aes(x = Sepal.Length, y = Petal.Length, color = Petal.Width)) +
  geom_point()
p_3_2

## ------------------------------------------------------------------------
# shapeで形になります
p_3_3 <- ggplot(iris, aes(x = Sepal.Length, y = Petal.Length, shape = Species)) + 
  geom_point()
p_3_3

## ------------------------------------------------------------------------
# デフォルトを作っておく
p_4_0 <- ggplot(iris, aes(x = Sepal.Length, y = Petal.Length, color = Species)) +
  geom_point()

# y軸を0から7までに
p_4_0 + scale_y_continuous(limits = c(0, 7))

## ------------------------------------------------------------------------
# 白黒系テーマを当ててみる
p_4_0 + theme_bw()

## ------------------------------------------------------------------------
p_4_0 +
  labs(title = "タイトルだよー",
       subtitle = "サブタイトルだよー",
       caption =  "図のキャプションだよーだよー",
       x = "えっくすじくだよー",
       y = "わいじくだよー",
       color = "からーだよー")

## ------------------------------------------------------------------------
# Speciesごとに分けて、行方向にプロット
# vars()で与えればOK
p_4_0 +
  facet_grid(rows = vars(Species))

## ------------------------------------------------------------------------
# 行数や列数を指定する場合はfacet_wrapの方が便利
# 切り分ける変数はformulaで与える
p_4_0 +
  facet_wrap(~Species, nrow = 2)

## ------------------------------------------------------------------------
# 横軸と縦軸を入れ替える場合はcoord_flipを当てる
p_4_0 +
  coord_flip()

## ------------------------------------------------------------------------
ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Petal.Length, shape = Species)) +
  geom_point()

## ------------------------------------------------------------------------
ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point() +
  geom_smooth(method = "lm")

## ------------------------------------------------------------------------
ggplot(iris, aes(x = Sepal.Length)) +
  geom_histogram()

## ------------------------------------------------------------------------
# geom_histgramにbin_width引数で区間の幅を、bins引数で区間数を指定できます
ggplot(iris, aes(x = Sepal.Length)) +
  geom_histogram(bins = 10)

## ------------------------------------------------------------------------
# aesにてfillを指定
# barの場合、colorは外枠でfillが塗りつぶしになります
ggplot(iris, aes(x = Sepal.Length, fill = Species)) +
  geom_histogram(bins = 10)

## ------------------------------------------------------------------------
ggplot(iris, aes(x = Species, y = Sepal.Length)) +
  geom_boxplot()

## ------------------------------------------------------------------------
ggplot(iris, aes(x = Species, y = Sepal.Length)) +
  geom_boxplot() +
  geom_jitter()

## ------------------------------------------------------------------------
ggplot(iris, aes(x = Species, y = Sepal.Length)) +
  geom_violin()

## ------------------------------------------------------------------------
# サンプルデータ作成
df_1 <- data.frame(
  d1 = sample(letters[1:5], 300, replace = TRUE, prob = c(1, 2, 3, 4, 5)),
  d2 = sample(letters[18:20], 300, replace = TRUE, prob = c(1, 3, 6)),
  d3 = sample(letters[22:23], 300, replace = TRUE, prob = c(3, 7)),
  c1 = rnorm(300, 100, 10),
  c2 = rnorm(300, 150, 20),
  c3 = rnorm(300, 50, 10)
)

# 集計
library(tidyverse)
df_1_agg1 <- df_1 %>% 
  group_by(d1, d2) %>% 
  summarise(mean_c1 = mean(c1),
            se_c1 = sd(c1) / sqrt(n())) %>% 
  ungroup()

# 内容の確認
str(df_1_agg1)

## ------------------------------------------------------------------------
# position = "dodge"で横に並べる配置になる
ggplot(df_1_agg1, aes(x = d1, y = mean_c1, fill = d2)) +
  geom_bar(stat = "identity", position = "dodge")

## ------------------------------------------------------------------------
ggplot(df_1_agg1, aes(x = d1, y = mean_c1, fill = d2)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_errorbar(aes(ymax = mean_c1 + se_c1, ymin = mean_c1 - se_c1),
                width = 0.5, position = position_dodge(width = 0.9))

## ------------------------------------------------------------------------
# geom_barで使ったデータを利用します
# 第3の
ggplot(df_1_agg1, aes(x = d1, y = d2, fill = mean_c1)) +
  geom_tile()

## ------------------------------------------------------------------------
ggplot(df_1_agg1, aes(x = d1, y = d2, fill = mean_c1)) +
  geom_tile() +
  geom_text(aes(label = round(mean_c1, digits = 1)), color = "white")

