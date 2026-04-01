import SwiftUI

struct DetailView: View {
    let item: Item
    @State private var showRecipeSide = false

    private var recipeKey: String {
        item.url.deletingPathExtension().lastPathComponent.lowercased()
            .replacingOccurrences(of: "_", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: " ", with: "")
    }

    private var drinkTitle: String {
        item.url.deletingPathExtension().lastPathComponent.cocktailDisplayTitle
    }

    private var recipeText: String {
        CocktailRecipes.recipes[recipeKey] ?? CocktailRecipes.fallback(for: drinkTitle)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Tap the card to flip between the photo and recipe.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)

                ZStack {
                    frontCard
                        .opacity(showRecipeSide ? 0 : 1)
                        .rotation3DEffect(
                            .degrees(showRecipeSide ? 180 : 0),
                            axis: (x: 0, y: 1, z: 0)
                        )

                    backCard
                        .opacity(showRecipeSide ? 1 : 0)
                        .rotation3DEffect(
                            .degrees(showRecipeSide ? 0 : -180),
                            axis: (x: 0, y: 1, z: 0)
                        )
                }
                .animation(.easeInOut(duration: 0.45), value: showRecipeSide)
                .onTapGesture {
                    showRecipeSide.toggle()
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle(drinkTitle)
        .navigationBarTitleDisplayMode(.inline)
        .background(
            LinearGradient(
                colors: [Color.orange.opacity(0.08), Color.pink.opacity(0.06), Color.clear],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }

    private var frontCard: some View {
        VStack(spacing: 0) {
            AsyncImage(url: item.url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    ZStack {
                        Color.gray.opacity(0.12)
                        Image(systemName: "photo")
                            .font(.system(size: 40))
                            .foregroundColor(.secondary)
                    }
                default:
                    ZStack {
                        Color.gray.opacity(0.08)
                        ProgressView()
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 300)
            .clipped()

            VStack(alignment: .leading, spacing: 6) {
                Text(drinkTitle)
                    .font(.title3.weight(.semibold))
                Label("Tap to flip for recipe", systemImage: "arrow.triangle.2.circlepath")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(.ultraThinMaterial)
        }
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(.white.opacity(0.25), lineWidth: 1)
        }
        .shadow(radius: 8, y: 4)
    }

    private var backCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("\(drinkTitle) Recipe", systemImage: "wineglass")
                    .font(.headline)
                Spacer()
                Text("Tap to flip")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Divider()

            Text(recipeText)
                .font(.body)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer(minLength: 0)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 380, alignment: .topLeading)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color.orange.opacity(0.25), lineWidth: 1)
        }
        .shadow(radius: 8, y: 4)
    }
}

private enum CocktailRecipes {
    static let recipes: [String: String] = [
        "mojito": "Ingredients\n• 2 oz white rum\n• 1 oz lime juice\n• 2 tsp sugar (or 3/4 oz simple syrup)\n• 6–8 mint leaves\n• Soda water\n• Ice\n\nDirections\n1. Muddle mint, sugar, and lime.\n2. Add rum and ice.\n3. Top with soda water and stir gently.\n4. Garnish with mint/lime.",
        "margarita": "Ingredients\n• 2 oz tequila\n• 1 oz lime juice\n• 1 oz triple sec\n• Ice\n• Salt rim (optional)\n\nDirections\n1. Shake tequila, lime, and triple sec with ice.\n2. Strain into a glass (salted rim optional).\n3. Garnish with lime wedge.",
        "oldfashioned": "Ingredients\n• 2 oz bourbon or rye\n• 1/4 oz simple syrup\n• 2 dashes Angostura bitters\n• Orange peel\n• Ice\n\nDirections\n1. Stir whiskey, syrup, and bitters with ice.\n2. Strain over fresh ice.\n3. Express orange peel over drink and garnish.",
        "oldfashionedcocktail": "Ingredients\n• 2 oz bourbon or rye\n• 1/4 oz simple syrup\n• 2 dashes Angostura bitters\n• Orange peel\n• Ice\n\nDirections\n1. Stir whiskey, syrup, and bitters with ice.\n2. Strain over fresh ice.\n3. Express orange peel over drink and garnish.",
        "espressomartini": "Ingredients\n• 2 oz vodka\n• 1 oz coffee liqueur\n• 1 oz fresh espresso (cooled)\n• Ice\n\nDirections\n1. Shake hard with ice until frothy.\n2. Strain into a martini glass.\n3. Garnish with coffee beans (optional).",
        "cosmopolitan": "Ingredients\n• 1.5 oz vodka\n• 1 oz cranberry juice\n• 0.5 oz triple sec\n• 0.5 oz lime juice\n• Ice\n\nDirections\n1. Shake all ingredients with ice.\n2. Strain into a coupe or martini glass.\n3. Garnish with orange peel or lime.",
        "cosmo": "Ingredients\n• 1.5 oz vodka\n• 1 oz cranberry juice\n• 0.5 oz triple sec\n• 0.5 oz lime juice\n• Ice\n\nDirections\n1. Shake all ingredients with ice.\n2. Strain into a coupe or martini glass.\n3. Garnish with orange peel or lime.",
        "negroni": "Ingredients\n• 1 oz gin\n• 1 oz Campari\n• 1 oz sweet vermouth\n• Ice\n• Orange peel\n\nDirections\n1. Stir ingredients with ice.\n2. Strain over fresh ice.\n3. Garnish with orange peel.",
        "whiskeysour": "Ingredients\n• 2 oz whiskey\n• 3/4 oz lemon juice\n• 3/4 oz simple syrup\n• Ice\n• Egg white (optional)\n\nDirections\n1. (Optional) Dry shake with egg white.\n2. Shake again with ice.\n3. Strain into rocks glass.\n4. Garnish with cherry/lemon.",
        "pinacolada": "Ingredients\n• 2 oz white rum\n• 1.5 oz cream of coconut\n• 1.5 oz pineapple juice\n• Ice\n\nDirections\n1. Blend with ice until smooth.\n2. Pour into chilled glass.\n3. Garnish with pineapple or cherry.",
        "manhattan": "Ingredients\n• 2 oz rye or bourbon\n• 1 oz sweet vermouth\n• 2 dashes bitters\n• Ice\n\nDirections\n1. Stir with ice.\n2. Strain into coupe glass.\n3. Garnish with cherry.",
        "dirtymartini": "Ingredients\n• 2.5 oz gin or vodka\n• 0.5 oz dry vermouth\n• 0.5 oz olive brine\n• Ice\n\nDirections\n1. Stir or shake with ice.\n2. Strain into chilled martini glass.\n3. Garnish with olives.",
        "martini": "Ingredients\n• 2.5 oz gin (or vodka)\n• 0.5 oz dry vermouth\n• Ice\n\nDirections\n1. Stir with ice until cold.\n2. Strain into chilled martini glass.\n3. Garnish with olive or lemon twist.",
        "paloma": "Ingredients\n• 2 oz tequila\n• 0.5 oz lime juice\n• Grapefruit soda\n• Ice\n• Salt rim (optional)\n\nDirections\n1. Add tequila and lime over ice.\n2. Top with grapefruit soda.\n3. Stir gently and garnish with lime.",
        "longisland": "Ingredients\n• 2 oz vodka\n• 2 oz tequila\n• 2 oz white rum\n• 2 oz gin\n• 2 oz triple sec\n• 2 oz lemon juice\n• 2 oz simple syrup\n• Cola to top\n• Ice\n\nDirections\n1. Add spirits, lemon juice, and syrup to a tall glass with ice.\n2. Top with a splash of cola.\n3. Stir gently and garnish with lemon.",
        "longislandicedtea": "Ingredients\n• 0.5 oz vodka\n• 0.5 oz tequila\n• 0.5 oz white rum\n• 0.5 oz gin\n• 0.5 oz triple sec\n• 0.75 oz lemon juice\n• 0.5 oz simple syrup\n• Cola to top\n• Ice\n\nDirections\n1. Shake spirits, lemon juice, and syrup with ice.\n2. Pour into tall glass over ice.\n3. Top with cola and garnish with lemon.",
        "bluelongisland": "Ingredients\n• 0.5 oz vodka\n• 0.5 oz tequila\n• 0.5 oz white rum\n• 0.5 oz gin\n• 0.5 oz blue curaçao\n• 0.75 oz lemon juice\n• 0.5 oz simple syrup\n• Lemon-lime soda (or splash of cola)\n• Ice\n\nDirections\n1. Shake spirits, blue curaçao, lemon juice, and syrup with ice.\n2. Pour into tall glass over fresh ice.\n3. Top with soda and garnish with lemon or mint.",
        "lycheemartini": "Ingredients\n• 2 oz vodka\n• 1 oz lychee liqueur (or syrup)\n• 0.5 oz dry vermouth (optional)\n• 0.5 oz lime juice\n• Ice\n\nDirections\n1. Shake all ingredients with ice.\n2. Strain into chilled martini glass.\n3. Garnish with lychee fruit.",
        "tomcollins": "Ingredients\n• 2 oz gin\n• 1 oz lemon juice\n• 0.5 oz simple syrup\n• Club soda\n• Ice\n\nDirections\n1. Add gin, lemon juice, and syrup to a tall glass with ice.\n2. Top with club soda.\n3. Stir gently and garnish with lemon."
    ]

    static func fallback(for title: String) -> String {
        "No recipe mapped yet for \(title).\\n\\nQuick fix: rename the image file to a cocktail name like mojito.jpg, margarita.jpg, negroni.jpg, or oldfashioned.jpg, longisland.jpeg, or tomcollins.jpeg and this card will auto-load a recipe."
    }
}

private extension String {
    var cocktailDisplayTitle: String {
        self
            .replacingOccurrences(of: "_", with: " ")
            .replacingOccurrences(of: "-", with: " ")
            .replacingOccurrences(of: "([a-z])([A-Z])", with: "$1 $2", options: .regularExpression)
            .split(separator: " ")
            .map { part in
                let lower = part.lowercased()
                switch lower {
                case "and": return "&"
                case "pina": return "Piña"
                default: return lower.prefix(1).uppercased() + lower.dropFirst()
                }
            }
            .joined(separator: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        if let url = Bundle.main.url(forResource: "mojito", withExtension: "jpg") ?? Bundle.main.url(forResource: "margarita", withExtension: "jpg") {
            DetailView(item: Item(url: url))
        }
    }
}
