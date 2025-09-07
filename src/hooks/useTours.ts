import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';

interface Tour {
  id: string;
  name: string;
  description?: string;
  vehicle_type: string;
  price_min: number;
  price_max?: number;
  capacity: number;
  duration: string;
  active: boolean;
}

interface HelicopterTour {
  id: string;
  name: string;
  duration: string;
  normal_price: number;
  voucher_price: number;
  discount_percentage: number;
  max_passengers: number;
  active: boolean;
}

export function useTours() {
  const [tours, setTours] = useState<Tour[]>([]);
  const [helicopterTours, setHelicopterTours] = useState<HelicopterTour[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    async function fetchTours() {
      try {
        setLoading(true);
        setError(null);

        // Buscar passeios terrestres
        const { data: toursData, error: toursError } = await supabase
          .from('jeri_agency_tours')
          .select('*')
          .eq('active', true)
          .order('name');

        if (toursError) {
          console.error('Erro ao buscar tours:', toursError);
        } else {
          setTours(toursData || []);
        }

        // Buscar voos de helicóptero
        const { data: helicopterData, error: helicopterError } = await supabase
          .from('jeri_agency_helicopter_tours')
          .select('*')
          .eq('active', true)
          .order('name');

        if (helicopterError) {
          console.error('Erro ao buscar voos de helicóptero:', helicopterError);
        } else {
          setHelicopterTours(helicopterData || []);
        }

      } catch (err) {
        console.error('Erro geral ao buscar dados:', err);
        setError('Erro ao carregar dados dos passeios');
      } finally {
        setLoading(false);
      }
    }

    fetchTours();
  }, []);

  return {
    tours,
    helicopterTours,
    loading,
    error
  };
}