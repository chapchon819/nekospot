module DiagnosticsHelper
    def result_contents(category)
            case category.name
            when '猫カフェ'
                { content: "猫スポットの代表！", image: 'cafe.webp' } 
            when '島'
                { content: "人間より猫の方が多い?!", image: 'island.webp' } 
            when '動物園'
                { content: "猫にも会える！", image: 'zoo.webp' } 
            when '宿泊施設'
                { content: "看板猫がいる", image: 'hotel.webp' }
            when '駅・バス停'
                { content: "看板猫がいる", image: 'default.webp' }
            when '飲食店'
                { content: "看板猫がいる", image: 'eating.webp' }
            when 'アニマルカフェ'
                { content: "猫以外の動物ともふれあえる！", image: 'animal_cafe.webp' }
            when '書店・雑貨店'
                { content: "看板猫がいる", image: 'shop.webp' }
            when '公園'
                { content: "猫とのふれあいスペースがある！", image: 'park.webp' } 
            when 'シェルター'
                { content: "新しい家族に出会えるかも？", image: 'shelter.webp' }
            when '銭湯'
                { content: "看板猫がいる", image: 'furo.webp' }
            else 
                "おすすめの猫スポットはありませんでした"
        end
    end
end