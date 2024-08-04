import SwiftUI

struct TagView: View {
    var tags: [String]
    
    var body: some View {
        HStack {
            ForEach(tags.filter { !$0.isEmpty }, id: \.self) { tag in
                let color = colorForTag(tag)
                Text(tag)
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(color, lineWidth: 2))
                    .foregroundColor(color)
                    .padding(.trailing, 4)
            }
        }
    }
    
    func colorForTag(_ tag: String) -> Color {
        let chestKeywords = ["chest", "pec", "pectorals", "tits", "titties", "tiddies", "boobs", "boobies", "milkers"]
        let absKeywords = ["abs", "abdominal", "core"]
        let backKeywords = ["back", "upper back", "mid back", "lats", "latissimus"]
        let bicepKeywords = ["bicep", "biceps", "brachialis", "bis", "biceps"]
        let calvesKeywords = ["calves", "calf", "tibia", "tib", "tibs", "tibias"]
        let cardioKeywords = ["cardio", "aerobic", "cardiovascular"]
        let coreKeywords = ["core", "hip flexors", "hips"]
        let glutesKeywords = ["glutes", "gluteus", "butt", "buttocks", "ass"]
        let hamKeywords = ["ham", "hamstring", "hamstrings", "hammies"]
        let legsKeywords = ["leg", "legs"]
        let lowerBackKeywords = ["lower back", "lumbar", "lowback", "low back"]
        let neckKeywords = ["neck", "cervical"]
        let obliqueKeywords = ["obliques", "oblique"]
        let pullKeywords = ["pull", "pull day"]
        let quadKeywords = ["quad", "quadriceps", "quads"]
        let shoulderKeywords = ["shoulder", "deltoid", "shoulders"]
        let stretchingKeywords = ["stretch", "stretching", "flexibility", "mobility"]
        let trapKeywords = ["trap", "trapezius"]
        let tricepKeywords = ["tricep", "triceps"]
        
        let keywordsToColor: [(keywords: [String], color: Color)] = [
            (absKeywords, .abs),
            (backKeywords, .back),
            (bicepKeywords, .bicep),
            (calvesKeywords, .calves),
            (cardioKeywords, .cardio),
            (chestKeywords, .chest),
            (glutesKeywords, .glutes),
            (hamKeywords, .ham),
            (legsKeywords, .legs),
            (lowerBackKeywords, .lowerBack),
            (neckKeywords, .neck),
            (obliqueKeywords, .obliques),
            (pullKeywords, .pull),
            (quadKeywords, .quad),
            (shoulderKeywords, .shoulder),
            (stretchingKeywords, .stretching),
            (trapKeywords, .trap),
            (tricepKeywords, .tricep)
        ]
        
        for (keywords, color) in keywordsToColor {
            if keywords.contains(where: tag.lowercased().contains) {
                return color
            }
        }
        
        return randomColor()
    }
    
    func randomColor() -> Color {
        let red = Double.random(in: 0...1)
        let green = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)
        return Color(red: red, green: green, blue: blue)
    }
    
}
