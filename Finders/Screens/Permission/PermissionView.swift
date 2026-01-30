//
//  PermissionView.swift
//  Finders
//
//  Created by Tiago Prestes on 29/01/26.
//

import SwiftUI

struct PermissionView: View {
    
    @EnvironmentObject private var coordinator: Coordinator
    @EnvironmentObject private var permissionManager: LocationPermissionManager
    
    private func onTap() {
        if permissionManager.isDenied {
            permissionManager.redirectToSettings()
            return
        }
        
        permissionManager.requestAuthorization()
    }
    
    var body: some View {
        VStack(spacing: Spacing.xxl) {
            
            VStack(spacing: Spacing.lg) {
                Text("Permitir acesso à sua localização?")
                    .font(.title.bold())
                    .multilineTextAlignment(.center)
                
                if permissionManager.isDenied {
                    deniedPermissionInstructions
                } else {
                    undeterminedPermissionInstructions
                }
                
            }
            
            Button {
                onTap()
            } label: {
                Text(permissionManager.isDenied ? "Ir para Configurações"  : "Permitir")
            }
            
        }
        .frame(maxHeight: .infinity, alignment: .center)
        .padding(.horizontal, Spacing.md)
    }
    
    private var undeterminedPermissionInstructions: some View {
        Text("Utilizamos sua localização para processar dados geográficos e urbanos ao seu redor. Isso permite que o app calcule a distância e a direção exata entre sua posição atual e pontos de interesse.")
            .font(.callout)
            .fontWeight(.regular)
    }
    
    private var deniedPermissionInstructions: some View {
        VStack(spacing: Spacing.sm) {
            
            Text("Opa! Vimos que você recusou totalmente o acesso a sua localização. Para habilitá-lo, siga os passos abaixo:")
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: Spacing.xs) {
                Text("1. Pressione o botão abaixo para acessar as configurações do aplicativo.")
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("""
                2. Pressione na fileira "Localização". 
                """)
                .frame(maxWidth: .infinity, alignment: .leading)

                Text("""
                3. Selecione a opção "Durante o Uso do App".
                """)
                .frame(maxWidth: .infinity, alignment: .leading)

                Text("4. Retorne para o aplicativo.")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .font(.subheadline)
            .fontWeight(.regular)
            .foregroundStyle(Color.init(uiColor: .systemGray4))
            
        }
    }
    
}

#Preview {
    PermissionView()
}
