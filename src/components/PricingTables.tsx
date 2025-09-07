import React from 'react';
import { useTours } from '../hooks/useTours';
import { Loader2, Users, Clock, Car, Plane } from 'lucide-react';

export function PricingTables() {
  const { tours, helicopterTours, loading, error } = useTours();

  if (loading) {
    return (
      <div className="flex justify-center items-center py-12">
        <Loader2 className="animate-spin text-yellow-500" size={48} />
        <span className="ml-4 text-xl text-gray-300">Carregando preços...</span>
      </div>
    );
  }

  if (error) {
    return (
      <div className="text-center py-12">
        <p className="text-red-400 text-lg mb-4">Erro ao carregar preços</p>
        <p className="text-gray-400">Entre em contato para valores atualizados</p>
      </div>
    );
  }

  return (
    <div className="space-y-16">
      {/* Tours Terrestres */}
      {tours && tours.length > 0 && (
        <div>
          <h3 className="text-3xl font-bold text-center mb-8 text-yellow-500">
            Passeios Terrestres
          </h3>
          <div className="grid md:grid-cols-2 gap-8">
            {tours.map((tour) => (
              <div
                key={tour.id}
                className="bg-black rounded-lg p-6 border border-yellow-500 hover:border-yellow-400 transition-all duration-300 hover:shadow-2xl hover:shadow-yellow-500/10"
              >
                <div className="flex items-center mb-4">
                  <Car className="text-yellow-500 mr-3" size={24} />
                  <h4 className="text-xl font-bold text-yellow-500">{tour.name}</h4>
                </div>
                
                {tour.description && (
                  <p className="text-gray-300 mb-4">{tour.description}</p>
                )}
                
                <div className="space-y-3 mb-6">
                  <div className="flex items-center justify-between">
                    <span className="text-gray-400">Veículo:</span>
                    <span className="text-white capitalize">{tour.vehicle_type}</span>
                  </div>
                  <div className="flex items-center justify-between">
                    <span className="text-gray-400">Capacidade:</span>
                    <span className="text-white flex items-center">
                      <Users size={16} className="mr-1" />
                      {tour.capacity} pessoas
                    </span>
                  </div>
                  <div className="flex items-center justify-between">
                    <span className="text-gray-400">Duração:</span>
                    <span className="text-white flex items-center">
                      <Clock size={16} className="mr-1" />
                      {tour.duration}
                    </span>
                  </div>
                </div>
                
                <div className="text-center">
                  <div className="text-2xl font-bold text-yellow-500 mb-2">
                    R$ {tour.price_min.toLocaleString('pt-BR')}
                    {tour.price_max && tour.price_max !== tour.price_min && (
                      <span> - R$ {tour.price_max.toLocaleString('pt-BR')}</span>
                    )}
                  </div>
                  <p className="text-sm text-gray-400">Por pessoa</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Voos de Helicóptero */}
      {helicopterTours && helicopterTours.length > 0 && (
        <div>
          <h3 className="text-3xl font-bold text-center mb-8 text-yellow-500">
            Voos de Helicóptero
          </h3>
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
            {helicopterTours.map((flight) => (
              <div
                key={flight.id}
                className="bg-black rounded-lg p-6 border border-yellow-500 hover:border-yellow-400 transition-all duration-300 hover:shadow-2xl hover:shadow-yellow-500/10"
              >
                <div className="flex items-center mb-4">
                  <Plane className="text-yellow-500 mr-3" size={24} />
                  <h4 className="text-xl font-bold text-yellow-500">{flight.name}</h4>
                </div>
                
                <div className="space-y-3 mb-6">
                  <div className="flex items-center justify-between">
                    <span className="text-gray-400">Duração:</span>
                    <span className="text-white flex items-center">
                      <Clock size={16} className="mr-1" />
                      {flight.duration}
                    </span>
                  </div>
                  <div className="flex items-center justify-between">
                    <span className="text-gray-400">Passageiros:</span>
                    <span className="text-white flex items-center">
                      <Users size={16} className="mr-1" />
                      Até {flight.max_passengers}
                    </span>
                  </div>
                </div>
                
                <div className="space-y-4">
                  <div className="text-center">
                    <div className="text-lg text-gray-400 line-through">
                      R$ {flight.normal_price.toLocaleString('pt-BR')}
                    </div>
                    <div className="text-2xl font-bold text-yellow-500">
                      R$ {flight.voucher_price.toLocaleString('pt-BR')}
                    </div>
                    <div className="text-sm text-green-400">
                      {flight.discount_percentage}% de desconto
                    </div>
                    <p className="text-xs text-gray-400 mt-1">Por pessoa</p>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Fallback se não houver dados */}
      {(!tours || tours.length === 0) && (!helicopterTours || helicopterTours.length === 0) && (
        <div className="text-center py-12">
          <p className="text-gray-400 text-lg mb-4">
            Entre em contato para valores atualizados dos passeios
          </p>
          <a 
            href="https://wa.me/5585998018443" 
            target="_blank" 
            rel="noopener noreferrer"
            className="bg-yellow-500 text-black px-6 py-3 rounded-lg font-semibold hover:bg-yellow-600 transition-colors inline-block"
          >
            Consultar Preços
          </a>
        </div>
      )}
    </div>
  );
}