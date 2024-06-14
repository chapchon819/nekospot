module DiagnosticsHelper
    def result_contents(category)
            case category.name
            when '猫カフェ'
                { content: "猫スポットの代表！", image: 'cafe.png' } 
            when '島'
                { content: "人間より猫の方が多い?!", image: 'island.png' } 
            when '動物園'
                { content: "猫にも会える！", image: 'zoo.png' } 
            when '宿泊施設'
                { content: "看板猫がいる", image: 'hotel.png' }
            when '駅・バス停'
                { content: "看板猫がいる", image: 'default.png' }
            when '飲食店'
                { content: "看板猫がいる", image: 'eating.png' }
            when 'アニマルカフェ'
                { content: "猫以外の動物ともふれあえる！", image: 'animal_cafe.png' }
            when '書店・雑貨店'
                { content: "看板猫がいる", image: 'shop.png' }
            when '公園'
                { content: "猫とのふれあいスペースがある！", image: 'park.png' } 
            when 'シェルター'
                { content: "新しい家族に出会えるかも？", image: 'shelter.png' }
            when '銭湯'
                { content: "看板猫がいる", image: 'furo.png' }
            else 
                "おすすめの猫スポットはありませんでした"
        end
    end
end