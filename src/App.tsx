import React, { useState, useEffect } from 'react';
import { Camera, Star, Clock, Users, Phone, Instagram, MapPin, User, Check, Sun, Sunset, Moon, Info, Menu, X, ArrowRight, ArrowLeft, Heart } from 'lucide-react';
import { PricingTables } from './components/PricingTables';

function App() {
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const [isScrolled, setIsScrolled] = useState(false);

  useEffect(() => {
    const handleScroll = () => {
      setIsScrolled(window.scrollY > 100);
    };

    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  const scrollToSection = (sectionId: string) => {
    const element = document.getElementById(sectionId);
    if (element) {
      element.scrollIntoView({ behavior: 'smooth' });
      setIsMenuOpen(false);
    }
  };

  return (
    <div className="bg-black text-white min-h-screen">
      {/* Navigation */}
      <nav className={`fixed w-full top-0 z-50 py-4 transition-all duration-300 ${
        isScrolled ? 'bg-black/95 backdrop-blur-lg' : 'bg-transparent'
      }`}>
        <div className="container mx-auto px-6 flex justify-between items-center">
          <div className="flex items-center space-x-3">
            <img 
              src="/imagens/perfil/logo.png" 
              alt="Logo Valdigley" 
              className="h-12 w-12 object-contain"
              onError={(e) => {
                e.currentTarget.src = 'https://images.pexels.com/photos/1264210/pexels-photo-1264210.jpeg?auto=compress&cs=tinysrgb&w=100&h=100&fit=crop';
              }}
            />
            <span className="text-2xl font-bold text-yellow-500">Valdigley</span>
          </div>
          
          <div className="hidden md:flex space-x-8">
            <button onClick={() => scrollToSection('home')} className="hover:text-yellow-500 transition-colors">Início</button>
            <button onClick={() => scrollToSection('locais')} className="hover:text-yellow-500 transition-colors">Locais</button>
            <button onClick={() => scrollToSection('passeios')} className="hover:text-yellow-500 transition-colors">Passeios</button>
            <button onClick={() => scrollToSection('precos')} className="hover:text-yellow-500 transition-colors">Preços</button>
            <a href="https://www.valdigley.com/portfolio/tag/jeri" target="_blank" rel="noopener noreferrer" className="hover:text-yellow-500 transition-colors">Ver Trabalhos</a>
            <button onClick={() => scrollToSection('contato')} className="hover:text-yellow-500 transition-colors">Contato</button>
          </div>
          
          <button 
            className="md:hidden text-yellow-500"
            onClick={() => setIsMenuOpen(!isMenuOpen)}
          >
            {isMenuOpen ? <X size={24} /> : <Menu size={24} />}
          </button>
        </div>
        
        {/* Mobile Menu */}
        {isMenuOpen && (
          <div className="md:hidden bg-black/95 backdrop-blur-lg mt-4 border-t border-yellow-500/20">
            <div className="px-6 py-4 space-y-4">
              <button onClick={() => scrollToSection('home')} className="block w-full text-left hover:text-yellow-500 transition-colors">Início</button>
              <button onClick={() => scrollToSection('locais')} className="block w-full text-left hover:text-yellow-500 transition-colors">Locais</button>
              <button onClick={() => scrollToSection('passeios')} className="block w-full text-left hover:text-yellow-500 transition-colors">Passeios</button>
              <button onClick={() => scrollToSection('precos')} className="block w-full text-left hover:text-yellow-500 transition-colors">Preços</button>
              <a href="https://www.valdigley.com/portfolio/tag/jeri" target="_blank" rel="noopener noreferrer" className="block hover:text-yellow-500 transition-colors">Ver Trabalhos</a>
              <button onClick={() => scrollToSection('contato')} className="block w-full text-left hover:text-yellow-500 transition-colors">Contato</button>
            </div>
          </div>
        )}
      </nav>

      {/* Hero Section */}
      <section id="home" className="relative min-h-screen flex items-center justify-center">
        <div 
          className="absolute inset-0 bg-cover bg-center bg-fixed"
          style={{
            backgroundImage: `linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)), url('/imagens/duna_por_do_sol.jpg')`,
          }}
          onError={(e) => {
            e.currentTarget.style.backgroundImage = `linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)), url('https://images.pexels.com/photos/1450353/pexels-photo-1450353.jpeg?auto=compress&cs=tinysrgb&w=1920&h=1080&fit=crop')`;
          }}
        />
        
        <div className="relative z-10 container mx-auto px-6 text-center">
          <div className="max-w-4xl mx-auto">
            <div className="hidden md:block mb-8">
              <img 
                src="/imagens/perfil/logo.png" 
                alt="Logo Valdigley" 
               className="h-32 w-32 mx-auto object-contain"
                onError={(e) => {
                  e.currentTarget.src = 'https://images.pexels.com/photos/1264210/pexels-photo-1264210.jpeg?auto=compress&cs=tinysrgb&w=200&h=200&fit=crop';
                }}
              />
            </div>
            
            <h1 className="text-5xl md:text-7xl font-bold mb-6 text-yellow-500 animate-fade-in">
              Jericoacoara
            </h1>
            <h2 className="text-3xl md:text-4xl font-light mb-8 animate-fade-in-delay">
              Paraíso Fotográfico do Ceará
            </h2>
            <p className="text-xl md:text-2xl mb-12 text-gray-300 animate-fade-in-delay-2">
              Capture momentos únicos nos locais mais deslumbrantes do Brasil
            </p>
            
            <div className="flex flex-col sm:flex-row gap-4 justify-center animate-fade-in-delay-3">
              <button 
                onClick={() => scrollToSection('precos')}
                className="bg-yellow-500 text-black px-8 py-3 rounded-lg font-semibold hover:bg-yellow-600 transition-all duration-300 hover:scale-105"
              >
                Ver Preços
              </button>
              <a 
                href="https://www.valdigley.com/portfolio/tag/jeri" 
                target="_blank" 
                rel="noopener noreferrer"
                className="border-2 border-yellow-500 text-yellow-500 px-8 py-3 rounded-lg font-semibold hover:bg-yellow-500 hover:text-black transition-all duration-300 hover:scale-105"
              >
                Ver Trabalhos
              </a>
              <a 
                href="https://wa.me/5585998018443" 
                target="_blank" 
                rel="noopener noreferrer"
                className="border-2 border-yellow-500 text-yellow-500 px-8 py-3 rounded-lg font-semibold hover:bg-yellow-500 hover:text-black transition-all duration-300 hover:scale-105"
              >
                Falar com Valdigley
              </a>
            </div>
            
            <div className="mt-12 text-center animate-fade-in-delay-4">
              <p className="text-lg text-gray-300 mb-4">Fotógrafo Profissional</p>
              <div className="flex flex-col sm:flex-row justify-center items-center space-y-2 sm:space-y-0 sm:space-x-6">
                <div className="flex items-center space-x-2">
                  <Phone className="text-yellow-500" size={20} />
                  <span>(85) 99801-8443</span>
                </div>
                <div className="flex items-center space-x-2">
                  <Instagram className="text-yellow-500" size={20} />
                  <span>@valdigley</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* About Jericoacoara */}
      <section className="py-20 bg-black">
        <div className="container mx-auto px-6">
          <div className="max-w-6xl mx-auto">
            <h2 className="text-4xl md:text-5xl font-bold text-center mb-16 text-yellow-500">
              Por que Jericoacoara é Especial?
            </h2>
            <div className="grid md:grid-cols-2 gap-12 items-center">
              <div className="order-2 md:order-1">
                <img 
                  src="/imagens/vila_jericoacoara.jpg" 
                  alt="Vila de Jericoacoara" 
                  className="rounded-lg shadow-2xl w-full h-80 object-cover"
                  onError={(e) => {
                    e.currentTarget.src = 'https://images.pexels.com/photos/1450353/pexels-photo-1450353.jpeg?auto=compress&cs=tinysrgb&w=800&h=600&fit=crop';
                  }}
                />
              </div>
              <div className="space-y-6 order-1 md:order-2">
                <div className="flex items-start space-x-4 group">
                  <Star className="text-yellow-500 text-2xl mt-1 group-hover:scale-110 transition-transform" size={24} />
                  <div>
                    <h3 className="text-xl font-semibold mb-2">Patrimônio Natural</h3>
                    <p className="text-gray-300">Parque Nacional protegido pela UNESCO com paisagens únicas no mundo.</p>
                  </div>
                </div>
                <div className="flex items-start space-x-4 group">
                  <Camera className="text-yellow-500 text-2xl mt-1 group-hover:scale-110 transition-transform" size={24} />
                  <div>
                    <h3 className="text-xl font-semibold mb-2">Cenários Únicos</h3>
                    <p className="text-gray-300">Dunas, lagoas cristalinas, praias selvagens e formações rochosas espetaculares.</p>
                  </div>
                </div>
                <div className="flex items-start space-x-4 group">
                  <Sun className="text-yellow-500 text-2xl mt-1 group-hover:scale-110 transition-transform" size={24} />
                  <div>
                    <h3 className="text-xl font-semibold mb-2">Luz Perfeita</h3>
                    <p className="text-gray-300">300 dias de sol por ano com golden hour e blue hour espetaculares.</p>
                  </div>
                </div>
                <div className="flex items-start space-x-4 group">
                  <Heart className="text-yellow-500 text-2xl mt-1 group-hover:scale-110 transition-transform" size={24} />
                  <div>
                    <h3 className="text-xl font-semibold mb-2">Experiência Única</h3>
                    <p className="text-gray-300">Vila rústica com ruas de areia e atmosfera mágica que encanta visitantes do mundo todo.</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Iconic Locations */}
      <section id="locais" className="py-20 bg-gray-900">
        <div className="container mx-auto px-6">
          <h2 className="text-4xl md:text-5xl font-bold text-center mb-16 text-yellow-500">
            Locais Icônicos para Fotos
          </h2>
          <div className="grid md:grid-cols-3 gap-8">
            {/* Duna do Pôr do Sol */}
            <div className="bg-black rounded-lg overflow-hidden border border-yellow-500 hover:border-yellow-400 transition-all duration-300 hover:transform hover:scale-105 hover:shadow-2xl hover:shadow-yellow-500/20">
              <img 
                src="/imagens/duna_por_do_sol.jpg" 
                alt="Duna do Pôr do Sol" 
                className="w-full h-64 object-cover"
                onError={(e) => {
                  e.currentTarget.src = 'https://images.pexels.com/photos/1450353/pexels-photo-1450353.jpeg?auto=compress&cs=tinysrgb&w=600&h=400&fit=crop';
                }}
              />
              <div className="p-6">
                <h3 className="text-2xl font-bold mb-3 text-yellow-500">Duna do Pôr do Sol</h3>
                <p className="text-gray-300 mb-4">O cartão postal mais famoso de Jericoacoara. Ideal para fotos românticas e silhuetas espetaculares.</p>
                <div className="space-y-2">
                  <div className="flex items-center space-x-2">
                    <Clock className="text-yellow-500" size={16} />
                    <span className="text-sm">Melhor horário: 17h - 18h30</span>
                  </div>
                  <div className="flex items-center space-x-2">
                    <Camera className="text-yellow-500" size={16} />
                    <span className="text-sm">Silhuetas, casais, grupos</span>
                  </div>
                </div>
              </div>
            </div>

            {/* Pedra Furada */}
            <div className="bg-black rounded-lg overflow-hidden border border-yellow-500 hover:border-yellow-400 transition-all duration-300 hover:transform hover:scale-105 hover:shadow-2xl hover:shadow-yellow-500/20">
              <img 
                src="/imagens/pedra_furada.jpg" 
                alt="Pedra Furada" 
                className="w-full h-64 object-cover"
                onError={(e) => {
                  e.currentTarget.src = 'https://images.pexels.com/photos/1450353/pexels-photo-1450353.jpeg?auto=compress&cs=tinysrgb&w=600&h=400&fit=crop';
                }}
              />
              <div className="p-6">
                <h3 className="text-2xl font-bold mb-3 text-yellow-500">Pedra Furada</h3>
                <p className="text-gray-300 mb-4">Formação rochosa única com arco natural. Perfeita para fotos dramáticas e enquadramentos criativos.</p>
                <div className="space-y-2">
                  <div className="flex items-center space-x-2">
                    <Clock className="text-yellow-500" size={16} />
                    <span className="text-sm">Melhor horário: 06h - 07h</span>
                  </div>
                  <div className="flex items-center space-x-2">
                    <Camera className="text-yellow-500" size={16} />
                    <span className="text-sm">Retratos, paisagens, nascer do sol</span>
                  </div>
                </div>
              </div>
            </div>

            {/* Lagoas */}
            <div className="bg-black rounded-lg overflow-hidden border border-yellow-500 hover:border-yellow-400 transition-all duration-300 hover:transform hover:scale-105 hover:shadow-2xl hover:shadow-yellow-500/20">
              <img 
                src="/imagens/lagoa_paraiso.jpg" 
                alt="Lagoas" 
                className="w-full h-64 object-cover"
                onError={(e) => {
                  e.currentTarget.src = 'https://images.pexels.com/photos/1450353/pexels-photo-1450353.jpeg?auto=compress&cs=tinysrgb&w=600&h=400&fit=crop';
                }}
              />
              <div className="p-6">
                <h3 className="text-2xl font-bold mb-3 text-yellow-500">Lagoas Cristalinas</h3>
                <p className="text-gray-300 mb-4">Águas azul-turquesa em meio às dunas. Cenário paradisíaco para fotos refrescantes e coloridas.</p>
                <div className="space-y-2">
                  <div className="flex items-center space-x-2">
                    <Clock className="text-yellow-500" size={16} />
                    <span className="text-sm">Melhor horário: 10h - 16h</span>
                  </div>
                  <div className="flex items-center space-x-2">
                    <Camera className="text-yellow-500" size={16} />
                    <span className="text-sm">Fotos na água, relaxamento</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Tours */}
      <section id="passeios" className="py-20 bg-black">
        <div className="container mx-auto px-6">
          <h2 className="text-4xl md:text-5xl font-bold text-center mb-16 text-yellow-500">
            Passeios e Experiências
          </h2>
          <div className="grid md:grid-cols-2 gap-12">
            {/* East Tour */}
            <div className="bg-gray-900 rounded-lg p-8 border border-yellow-500 hover:border-yellow-400 transition-all duration-300 hover:shadow-2xl hover:shadow-yellow-500/10">
              <div className="flex items-center mb-6">
                <ArrowRight className="text-yellow-500 mr-4" size={32} />
                <h3 className="text-3xl font-bold text-yellow-500">Passeio Leste</h3>
              </div>
              <p className="text-gray-300 mb-6">Explore as lagoas mais famosas e os cenários paradisíacos do lado leste de Jericoacoara.</p>
              <div className="space-y-3 mb-6">
                <div className="flex items-center space-x-3">
                  <MapPin className="text-yellow-500" size={16} />
                  <span>Árvore da Preguiça</span>
                </div>
                <div className="flex items-center space-x-3">
                  <MapPin className="text-yellow-500" size={16} />
                  <span>Praia do Preá</span>
                </div>
                <div className="flex items-center space-x-3">
                  <MapPin className="text-yellow-500" size={16} />
                  <span>Lagoa Azul</span>
                </div>
                <div className="flex items-center space-x-3">
                  <MapPin className="text-yellow-500" size={16} />
                  <span>Lagoa do Paraíso</span>
                </div>
                <div className="flex items-center space-x-3">
                  <MapPin className="text-yellow-500" size={16} />
                  <span>Buraco Azul</span>
                </div>
              </div>
              <div className="flex items-center space-x-4 text-sm text-gray-400">
                <span><Clock className="inline mr-2" size={16} />8-10 horas</span>
                <span><Users className="inline mr-2" size={16} />Até 10 pessoas</span>
              </div>
            </div>

            {/* West Tour */}
            <div className="bg-gray-900 rounded-lg p-8 border border-yellow-500 hover:border-yellow-400 transition-all duration-300 hover:shadow-2xl hover:shadow-yellow-500/10">
              <div className="flex items-center mb-6">
                <ArrowLeft className="text-yellow-500 mr-4" size={32} />
                <h3 className="text-3xl font-bold text-yellow-500">Passeio Oeste</h3>
              </div>
              <p className="text-gray-300 mb-6">Descubra manguezais, dunas selvagens e a famosa Tatajuba no lado oeste de Jericoacoara.</p>
              <div className="space-y-3 mb-6">
                <div className="flex items-center space-x-3">
                  <MapPin className="text-yellow-500" size={16} />
                  <span>Praia do Mangue Seco</span>
                </div>
                <div className="flex items-center space-x-3">
                  <MapPin className="text-yellow-500" size={16} />
                  <span>Passeio do Cavalo Marinho</span>
                </div>
                <div className="flex items-center space-x-3">
                  <MapPin className="text-yellow-500" size={16} />
                  <span>Praia do Guriu</span>
                </div>
                <div className="flex items-center space-x-3">
                  <MapPin className="text-yellow-500" size={16} />
                  <span>Tirolesa e Toboágua</span>
                </div>
                <div className="flex items-center space-x-3">
                  <MapPin className="text-yellow-500" size={16} />
                  <span>Lago Grande de Tatajuba</span>
                </div>
              </div>
              <div className="flex items-center space-x-4 text-sm text-gray-400">
                <span><Clock className="inline mr-2" size={16} />8-10 horas</span>
                <span><Users className="inline mr-2" size={16} />Até 10 pessoas</span>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Pricing */}
      <section id="precos" className="py-20 bg-gray-900">
        <div className="container mx-auto px-6">
          <h2 className="text-4xl md:text-5xl font-bold text-center mb-16 text-yellow-500">
            Investimento
          </h2>
          
          {/* Photography Service */}
          <div className="max-w-4xl mx-auto mb-16">
            <div className="bg-black rounded-lg p-8 border-2 border-yellow-500 hover:border-yellow-400 transition-all duration-300 hover:shadow-2xl hover:shadow-yellow-500/20">
              <div className="text-center mb-8">
                <Camera className="text-yellow-500 mx-auto mb-4" size={48} />
                <h3 className="text-3xl font-bold text-yellow-500 mb-4">Serviço de Fotografia</h3>
                <p className="text-gray-300 text-lg">Sessão profissional com Valdigley</p>
              </div>
              <div className="grid md:grid-cols-2 gap-8">
                <div className="text-center">
                  <div className="text-4xl font-bold text-yellow-500 mb-2">R$ 1.000</div>
                  <div className="text-lg text-gray-300 mb-4">Meio Expediente (4h30)</div>
                  <div className="space-y-2 text-sm text-gray-400">
                    <div><Check className="inline text-yellow-500 mr-2" size={16} />Fotos ilimitadas</div>
                    <div><Check className="inline text-yellow-500 mr-2" size={16} />Edição profissional</div>
                    <div><Check className="inline text-yellow-500 mr-2" size={16} />Entrega digital via link</div>
                    <div><Check className="inline text-yellow-500 mr-2" size={16} />Todos os locais inclusos</div>
                  </div>
                </div>
                <div className="text-center">
                  <div className="text-lg text-gray-300 mb-4">Horários Sugeridos:</div>
                  <div className="space-y-2 text-sm text-gray-400">
                    <div><Sun className="inline text-yellow-500 mr-2" size={16} />Manhã: 07h às 11h30</div>
                    <div><Sunset className="inline text-yellow-500 mr-2" size={16} />Tarde: 14h às 18h30</div>
                    <div><Moon className="inline text-yellow-500 mr-2" size={16} />Golden Hour: 16h às 20h30</div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          {/* Tours Pricing */}
          <PricingTables />
        </div>
      </section>

      {/* Contact */}
      <section id="contato" className="py-20 bg-black">
        <div className="container mx-auto px-6">
          <div className="max-w-4xl mx-auto text-center">
            <h2 className="text-4xl md:text-5xl font-bold mb-8 text-yellow-500">
              Vamos Criar Memórias Únicas?
            </h2>
            <p className="text-xl text-gray-300 mb-12">
              Entre em contato e vamos planejar sua sessão de fotos dos sonhos em Jericoacoara
            </p>
            
            <div className="grid md:grid-cols-2 gap-12 items-center">
              <div className="order-2 md:order-1">
                <img 
                  src="/imagens/perfil/foto_valdiglei.jpg" 
                  alt="Valdigley Fotógrafo" 
                  className="rounded-lg shadow-2xl mx-auto w-full max-w-md h-80 object-cover object-center"
                  onError={(e) => {
                    e.currentTarget.src = 'https://images.pexels.com/photos/1264210/pexels-photo-1264210.jpeg?auto=compress&cs=tinysrgb&w=600&h=800&fit=crop';
                  }}
                />
              </div>
              <div className="space-y-8 order-1 md:order-2">
                <div className="text-left">
                  <h3 className="text-2xl font-bold mb-6 text-yellow-500">Informações de Contato</h3>
                  <div className="space-y-4">
                    <div className="flex items-center space-x-4 group">
                      <User className="text-yellow-500 group-hover:scale-110 transition-transform" size={24} />
                      <span className="text-lg">Valdigley</span>
                    </div>
                    <div className="flex items-center space-x-4 group">
                      <Phone className="text-yellow-500 group-hover:scale-110 transition-transform" size={24} />
                      <a href="tel:+5585998018443" className="text-lg hover:text-yellow-500 transition-colors">(85) 99801-8443</a>
                    </div>
                    <div className="flex items-center space-x-4 group">
                      <Instagram className="text-yellow-500 group-hover:scale-110 transition-transform" size={24} />
                      <a href="https://www.instagram.com/valdigley" target="_blank" rel="noopener noreferrer" className="text-lg hover:text-yellow-500 transition-colors">@valdigley</a>
                    </div>
                    <div className="flex items-center space-x-4 group">
                      <MapPin className="text-yellow-500 group-hover:scale-110 transition-transform" size={24} />
                      <span className="text-lg">Jericoacoara, Ceará</span>
                    </div>
                  </div>
                </div>
                
                <div className="space-y-4">
                  <a 
                    href="https://wa.me/5585998018443?text=Olá%20Valdigley!%20Gostaria%20de%20saber%20mais%20sobre%20sessões%20de%20fotos%20em%20Jericoacoara." 
                    target="_blank" 
                    rel="noopener noreferrer"
                    className="bg-gradient-to-r from-yellow-500 to-yellow-600 text-black px-8 py-4 rounded-full font-semibold text-lg hover:scale-105 transition-transform inline-block w-full text-center"
                  >
                    <Phone className="inline mr-2" size={20} />
                    Falar no WhatsApp
                  </a>
                  <a 
                    href="https://www.instagram.com/valdigley" 
                    target="_blank" 
                    rel="noopener noreferrer"
                    className="border-2 border-yellow-500 text-yellow-500 px-8 py-4 rounded-full font-semibold text-lg hover:bg-yellow-500 hover:text-black transition-all duration-300 hover:scale-105 inline-block w-full text-center"
                  >
                    <Instagram className="inline mr-2" size={20} />
                    Seguir no Instagram
                  </a>
                </div>
              </div>
            </div>
            
            <div className="mt-16 text-center">
              <p className="text-lg text-gray-400 italic">
                "Transformo momentos em memórias eternas nos cenários mais belos do Ceará"
              </p>
              <p className="text-xl font-semibold text-yellow-500 mt-4">
                - Valdigley, seu Fotógrafo em Jericoacoara
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-black py-8 border-t border-yellow-500">
        <div className="container mx-auto px-6 text-center">
          <div className="flex justify-center items-center space-x-3 mb-4">
            <img 
              src="/imagens/perfil/logo.png" 
              alt="Logo Valdigley" 
             className="h-8 w-8 object-contain"
              onError={(e) => {
                e.currentTarget.src = 'https://images.pexels.com/photos/1264210/pexels-photo-1264210.jpeg?auto=compress&cs=tinysrgb&w=50&h=50&fit=crop';
              }}
            />
            <span className="text-xl font-bold text-yellow-500">Valdigley</span>
          </div>
          <p className="text-gray-400">
            © 2025 Valdigley - Fotógrafo Profissional em Jericoacoara. Todos os direitos reservados.
          </p>
        </div>
      </footer>

      {/* Floating WhatsApp */}
      <a 
        href="https://wa.me/5585998018443?text=Olá%20Valdigley!%20Gostaria%20de%20saber%20mais%20sobre%20sessões%20de%20fotos%20em%20Jericoacoara." 
        target="_blank" 
        rel="noopener noreferrer"
        className="fixed bottom-6 right-6 z-50 bg-green-500 text-white rounded-full px-6 py-4 shadow-2xl hover:scale-110 transition-all duration-300 hover:shadow-green-500/50 flex items-center space-x-2"
      >
        <svg className="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
          <path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 005.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893A11.821 11.821 0 0020.885 3.488"/>
        </svg>
        <span className="hidden sm:inline font-medium">Falar com Valdigley</span>
      </a>
    </div>
  );
}

export default App;